package main

import (
	"flag"
	"fmt"
	"log"
)

type InputFlags struct {
	WebhookUrl string
}

func parseFlags() InputFlags {
	flags := InputFlags{}
	flag.StringVar(&flags.WebhookUrl, "w", "", "webhook url")

	if flags.WebhookUrl == "" {
		log.Fatalln("missing w flag")
	}

	return flags
}

func main() {
	flags := parseFlags()
	fmt.Println(flags)
}
