package env

import (
	"errors"
	"fmt"
	"os"

	awsUtils "github.com/EdgeJay/lifecyclebot/utils/aws"
)

func GetAWSParamStoreKeyName(name string) string {
	return fmt.Sprintf("/%s/%s/%s", GetAppName(), GetAppEnv(), name)
}

func GetAppName() string {
	return os.Getenv("app_name")
}

func GetAppEnv() string {
	return os.Getenv("app_env")
}

func GetAppVersion() string {
	return os.Getenv("app_version")
}

func GetTelegramBotToken() (string, error) {
	token := awsUtils.GetStringParameter(
		GetAWSParamStoreKeyName("telegram_bot_token"),
		"",
	)

	if token != "" {
		return token, nil
	} else {
		return "", errors.New("invalid Telegram bot token")
	}
}
