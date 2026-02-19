# 🖼️🤖 Prompture – Image and Video Generator Bot

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

## 📬 Bot Link

 If you have a token you can activate it right away
  - 👉 https://t.me/prompture_bot/start=YOUR_TOKEN
 
 Otherwise, just follow this link:
  - 👉 https://t.me/prompture_bot  

---

## 🔑 Credits & Tokens

Each generation costs credits.

To receive credits, you must activate a token.

If you are on this page, you most likely already have a token.

If not, please contact the owner of this repository to obtain one.

---

## 📸 Screenshots
![image](https://github.com/user-attachments/assets/c0dc84b1-a599-49a2-ad1a-f8db1d5890bd)

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

- Freepik and ChatGPT API
