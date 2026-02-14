# Treecal

A personal photo-a-day calendar app. Upload one photo per day, browse them in
a monthly calendar grid or a chronological camera roll, and navigate between
photos with arrow keys or swipe gestures.

## Features

- **Calendar view** — monthly grid with a thumbnail for each day you have a photo
- **Camera roll** — all photos in a responsive grid, oldest to newest, with empty-day placeholders
- **Single-user auth** — email/password login (no self-registration)
- **Bulk upload** — drop multiple files at once; filenames must be `YYYYMMDD.jpg` (or `.png`, `.webp`, `.heic`, etc.)
- **Keyboard & swipe navigation** — arrow keys and swipe gestures on both the calendar and individual photo views

## Requirements

- Ruby 3.4.7
- Bundler
- Node.js (for Tailwind CSS asset builds during development)

## Local development

```bash
git clone <repo>
cd treecal
bundle install
bin/rails db:prepare
bin/dev            # starts Rails + Tailwind watcher via Procfile.dev
```

Then open http://localhost:3000.

## Deployment (Docker)

The app ships with a production-ready multi-stage `Dockerfile`.

```bash
docker build -t treecal .
docker run -d -p 80:80 \
  -e RAILS_MASTER_KEY=<value from config/master.key> \
  -v treecal_storage:/rails/storage \
  --name treecal treecal
```

**Important:** SQLite and Active Storage files both live under `storage/`.
Mount a persistent volume there or you will lose data on container restart.

`RAILS_MASTER_KEY` is required to decrypt credentials. Keep `config/master.key`
out of version control (it is already in `.gitignore`).

## Tech stack

| Layer | Choice |
|---|---|
| Framework | Rails 8.1 |
| Database | SQLite 3 |
| Storage | Active Storage (local disk) |
| Image processing | image_processing / libvips |
| Styles | Tailwind CSS |
| JS | Stimulus + Turbo (importmap) |
| Web server | Puma + Thruster |
