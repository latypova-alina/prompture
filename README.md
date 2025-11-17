# 🖼️🤖 Prompture – Image Generator Bot

**Prompture** is a Telegram bot that helps you create images and videos from prompt you provide

---

## 📌 Features

- 💬 Extending prompt
- 🖼️ Generate images from prompt using the following processors:
  - **Mystic**
  - **Gemini**
  - **Imagen**
- 🎥 Generate videos from images using the following processors:
  - **Kling**

---

## 🛠️ Running Locally

If you want to run this bot on your own machine:

Run poller first:

```bash
bundle exec rake telegram:bot:poller

Then open sidekiq:

```bash
bundle exec sidekiq

Then open ngrok (for local webhooks)

```bash
ngrok http 3000
