---
name: get-yt-transcript
description: Download a YouTube video transcript as plain text. Asks for URL, output location (default: OneDrive transcripts folder), and format (default: English plain text). Saves with YYMMDD_channel_video_title naming convention.
argument-hint: <youtube_url>
---

Extract a transcript from a YouTube video.

## Input
The YouTube URL is provided as `$ARGUMENTS`. If no URL was given, ask the user for it before proceeding.

## Step 1: Confirm options with the user
Use `AskUserQuestion` to ask the following two questions **in a single call**:

**Question 1 — Output location**
- Header: "Save location"
- Default option (first): `C:\Users\msk\OneDrive\6_knowledge\transcripts\` (Recommended)
- Other option: "Custom path" — if selected, ask the user to type the path

**Question 2 — Language/format**
- Header: "Format"
- Default option (first): English plain text, no timestamps (Recommended)
- Other option: "With timestamps" — VTT-style, one line per cue
- Other option: "Other language" — ask user to specify language code

## Step 2: Download subtitles with yt-dlp

Run in a temp directory (`/tmp`):

```bash
cd /tmp && yt-dlp --write-auto-sub --sub-langs <lang> --sub-format vtt --skip-download \
  -o "%(upload_date)s_%(channel)s_%(title)s" "<URL>"
```

- Default `<lang>` is `en`
- The output `.vtt` filename will contain upload date, channel, and title

## Step 3: Build the output filename

From the downloaded `.vtt` filename (e.g. `20251001_Nick Saraev_How I Would Start...en.vtt`):

1. Strip the `.en.vtt` extension
2. Take the first 8 chars as YYYYMMDD, convert to YYMMDD by dropping the first 2 chars
3. Lowercase everything
4. Replace spaces and hyphens with `_`
5. Strip all characters that are not `a-z`, `0-9`, or `_`
6. Collapse consecutive underscores to one

Result example: `251001_nick_saraev_how_i_would_start_ai_consulting_in_2026_if_i_could_start_over`

## Step 4: Convert VTT → plain text

**Plain text (default):**
```bash
grep -v "^WEBVTT\|^NOTE\|^[0-9]\|^$\|-->" file.en.vtt \
  | sed 's/<[^>]*>//g' \
  | awk '!seen[$0]++' \
  > "<output_dir>/<filename>.txt"
```

**With timestamps:**
Keep the `-->` lines as section dividers, same stripping otherwise.

## Step 5: Confirm success

Tell the user:
- Full path of the saved file
- Line count

## Step 6: Skill evaluation

At the very end, use `AskUserQuestion` to ask:

> "How did this skill perform?"
> - Header: "Feedback"
> - Option 1: "+1 — worked well"
> - Option 2: "-1 — something went wrong"

If they select `-1`, ask a follow-up text question: "What went wrong?" and note it so improvements can be made.
