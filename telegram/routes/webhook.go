package routes

import (
	"fmt"

	"github.com/EdgeJay/lifecyclebot/telegram/bot"
	"github.com/gin-gonic/gin"
)

func Webhook(c *gin.Context) {
	tgBot := bot.GetTelegramBot()
	update, err := tgBot.HandleUpdate(c.Request)
	if err != nil {
		tgBot.SendTextMessage(
			bot.GetChatIDFromUpdate(update),
			"Oops something went wrong with the last message",
		)
	} else {
		tgBot.SendTextMessage(
			bot.GetChatIDFromUpdate(update),
			fmt.Sprintf("Got your message: %s", update.Message.Text),
		)
	}
}
