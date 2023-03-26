package main

import (
	"flag"
	"log"

	"github.com/EdgeJay/lifecyclebot/telegram/bot"
)

type InputFlags struct {
	WebhookUrl       string
	TelegramBotToken string
}

func parseFlags() InputFlags {
	flags := InputFlags{}
	flag.StringVar(&flags.WebhookUrl, "w", "", "Webhook url")
	flag.StringVar(&flags.TelegramBotToken, "t", "", "Telegram bot token")
	flag.Parse()

	if flags.WebhookUrl == "" {
		log.Fatalln("missing w flag")
	}

	if flags.TelegramBotToken == "" {
		log.Fatalln("missing t flag")
	}

	return flags
}

func main() {
	flags := parseFlags()
	bot.PostDeployInit(bot.PostDeployInitParams{
		WebhookUrl:       flags.WebhookUrl,
		TelegramBotToken: flags.TelegramBotToken,
	})
}
