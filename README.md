# 🖼️🤖 Prompture – Image and Video Generator Bot

**Prompture** is a Telegram bot that helps you create images and videos from prompt you provide

---

## 📌 Features

- 💬 Extend your prompt automatically before generation
- 🖼️ Generate images from a prompt using the following processors:
  - **Flux 2 Pro**
  - **NanoBanana 2**
- 🖼✏️ Edit an existing image with **NanoBanana 2 Edit**
- 🔊 Generate audio from a prompt using **ElevenLabs**
- 🎥 Generate videos from images using the following processors:
  - **Kling Pro 2.1**
  - **Kling 3 Standard**
  - **Hailuo 02 Standard**
  - **Veo 3.1 Lite**
- 🖼🎬 Turn a single picture into a video
- 🖼🎬 Turn a start & end frame into a video
- 🔁 Regenerate any generated result with one tap
- 🎧 Preview available voices with audio samples before generating audio

---

## 📬 Bot Link

 If you have a token you can activate it right away
  - 👉 https://t.me/prompture_bot/start=YOUR_TOKEN
 
 Otherwise, just follow this link:
  - 👉 https://t.me/prompture_bot  

---

## 🔑 Credits & Tokens

Credits (called **inks 🖋️** in the bot) are spent on every generation, e.g.:

- 🖼️ Image generation / editing — 2 inks
- 🔊 Audio generation — 2 inks
- 🎬 Video generation — 10–20 inks, depending on the processor
- 💬 Prompt extension — 2 inks

Check your balance anytime with `/balance`.

There are two ways to get credits:

- 🔑 **Activate a token** — if you are on this page, you most likely already have one. Use `/start YOUR_TOKEN` (or `/activate_token!` inside the bot) to redeem it. If you don't have a token, please contact the owner of this repository to obtain one.
- ⭐ **Buy inks with Telegram Stars** — use `/buy_inks` inside the bot to purchase a credit pack directly with Telegram Stars, no token needed.

---

## 📸 Screenshots
<img width="1215" height="1280" alt="photo_2026-08-09_17-37-10" src="https://github.com/user-attachments/assets/99f37da1-3cad-40e7-8de5-b4eabdd48ff9" />


---

## 🛠️ Running Locally

If you want to run this bot on your own machine (please note there is a special prompture_development bot for this https://t.me/prompture_development_bot):

Run poller first:

```bash
bundle exec rake telegram:bot:poller
```

Then open sidekiq:

```bash
bundle exec sidekiq
```

Then open ngrok (for local webhooks)

```bash
ngrok http 3000
```

Then open rails server:

```
rails s
```

---

## 🧠 Tech Stack

- Ruby on Rails 8

- Sidekiq

- Redis

- Telegram Bot API

- Fal and ChatGPT API
