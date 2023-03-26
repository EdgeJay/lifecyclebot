package bot

import (
	"log"
	"net/http"

	"github.com/EdgeJay/lifecyclebot/telegram/env"
	lambdaUtils "github.com/EdgeJay/lifecyclebot/utils/lambda"
	tgbotapi "github.com/go-telegram-bot-api/telegram-bot-api/v5"
)

type TelegramBot struct {
	bot *tgbotapi.BotAPI
}

type PostDeployInitParams struct {
	WebhookUrl       string
	TelegramBotToken string
}

var tgBot *TelegramBot

func init() {
	if !lambdaUtils.IsRunningInLambda() {
		return
	}

	if t, err := env.GetTelegramBotToken(); err != nil {
		log.Fatalln(err)
	} else {
		initBot(t)
	}
}

func initBot(token string) {
	bot, err := tgbotapi.NewBotAPI(token)
	if err != nil {
		log.Fatalln(err)
	}

	bot.Debug = !env.IsProductionEnv()

	tgBot = &TelegramBot{
		bot: bot,
	}
}

// Get singleton instance of TelegramBot
func GetTelegramBot() *TelegramBot {
	return tgBot
}

func (b *TelegramBot) GetBot() *tgbotapi.BotAPI {
	return b.bot
}

func (b *TelegramBot) HandleUpdate(r *http.Request) (*tgbotapi.Update, error) {
	return b.bot.HandleUpdate(r)
}

func (b *TelegramBot) SendTextMessage(chatID int64, text string) (tgbotapi.Message, error) {
	msg := tgbotapi.NewMessage(chatID, text)
	return b.bot.Send(msg)
}

func GetChatIDFromUpdate(update *tgbotapi.Update) int64 {
	return update.Message.Chat.ID
}

// This method is meant to be called only in deployment environment, in post-deployment stage.
func PostDeployInit(params PostDeployInitParams) {
	if lambdaUtils.IsRunningInLambda() {
		log.Fatalln("Stopping function execution, function should not be run in Lambda environment")
		return
	}

	initBot(params.TelegramBotToken)

	tgBot.bot.Debug = true

	// re-setup webhook
	newWebHook, err := tgbotapi.NewWebhookWithCert(
		params.WebhookUrl+"/bot"+params.TelegramBotToken,
		nil,
	)

	if err != nil {
		log.Fatalln("unable to create new webhook", err)
	}

	_, reqErr := tgBot.bot.Request(newWebHook)
	if reqErr != nil {
		log.Fatalln("webhook request via bot failed", reqErr)
	}
}
