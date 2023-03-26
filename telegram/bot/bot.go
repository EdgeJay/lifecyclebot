package bot

import (
	"log"

	"github.com/EdgeJay/lifecyclebot/telegram/env"
	tgbotapi "github.com/go-telegram-bot-api/telegram-bot-api/v5"
)

type TelegramBot struct {
	bot *tgbotapi.BotAPI
}

var tgBot *TelegramBot

func init() {
	var token string
	if t, err := env.GetTelegramBotToken(); err != nil {
		log.Fatalln(err)
	} else {
		token = t
	}

	bot, err := tgbotapi.NewBotAPI(token)
	if err != nil {
		log.Fatalln(err)
	}

	bot.Debug = !env.IsProductionEnv()

	tgBot = &TelegramBot{
		bot: bot,
	}
}

func GetTelegramBot() *TelegramBot {
	return tgBot
}
