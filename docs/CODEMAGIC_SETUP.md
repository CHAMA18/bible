# Codemagic Deployment — Setup Guide

This guide walks you through using **Codemagic** as an alternative CI/CD to
GitHub Actions for deploying the Bible app to the Google Play Store.

We're using Codemagic because the GitHub Actions account is currently locked
due to a billing issue. Codemagic is a CI/CD service purpose-built for mobile
apps and runs on real macOS hardware (free tier: 500 Linux+macOS minutes/month).

> **The codemagic.yaml pipeline is already committed to the repo.** You just
> need to connect the repo to Codemagic (one-time) and add the same 5
> secrets you already have in GitHub.

---

## 0. What's already done

- ✅ `codemagic.yaml` committed at repo root
- ✅ Release keystore generated (file: `bible-release.jks` in
  `/home/z/my-project/download/`)
- ✅ Google Cloud service account JSON created (project `bible-ba4b7`)
- ✅ All 5 secret values are stored in `PLAY_STORE_SECRETS.txt` and were
  uploaded to GitHub Actions secrets (you can reuse the exact same values
  in Codemagic)

---

## 1. Connect the `CHAMA18/bible` repo to Codemagic (one-time, ~2 min)

This is the only step I cannot do via API — Codemagic requires OAuth-based
GitHub authorization done through their web UI.

1. Log in to https://codemagic.io (you already have an account — the API
   token you provided authenticated as `chungu424@gmail.com`).
2. Click **Add application** (top-right).
3. Select **GitHub** as the source.
4. Authorize Codemagic to access your GitHub account if you haven't already
   (it will request read access to your repos).
5. In the repo picker, search for `bible` and select `CHAMA18/bible`.
6. Project type: **Flutter App**.
7. Configuration: **codemagic.yaml** (this tells Codemagic to use the
   `codemagic.yaml` file in the repo rather than the UI-based config).
8. Click **Finish application**.

Once the app appears in your Codemagic dashboard, tell me — I'll use the
API to configure the secrets and trigger the first build.

---

## 2. Environment variable groups

The `codemagic.yaml` references two environment variable groups. You can
create these via the Codemagic UI (App → App settings → Environment
variables) OR I can create them via API once the app is connected.

### Group: `keystore_credentials`

| Variable name | Type | Value | Same as GitHub secret |
| --- | --- | --- | --- |
| `KEYSTORE_BASE64` | text | (base64 string from `PLAY_STORE_SECRETS.txt`) | ✅ Yes |
| `KEYSTORE_ALIAS` | text | `bible-key` | ✅ Yes |
| `KEYSTORE_PASSWORD` | text | (from `PLAY_STORE_SECRETS.txt`) | ✅ Yes |
| `KEY_PASSWORD` | text | (from `PLAY_STORE_SECRETS.txt`) | ✅ Yes |

### Group: `play_store_credentials`

| Variable name | Type | Value | Notes |
| --- | --- | --- | --- |
| `PLAY_SERVICE_ACCOUNT_JSON` | **file** | (raw JSON contents) | Codemagic writes the JSON to a temp file and the variable resolves to the file path. **Must be marked as Secure**. |

> ⚠️ The `PLAY_SERVICE_ACCOUNT_JSON` variable **must be created as a "file"
> type, not a "text" type**, otherwise Codemagic will try to use the JSON
> string as a file path and the upload will fail with a confusing error.

I'll set all 5 of these via the Codemagic API once you've connected the app.

---

## 3. Trigger the first build

### Option A — API (I'll do this once you've connected the app)

Once the app is connected, I'll:
1. Create both environment variable groups via API
2. Add all 5 variables via API (with `secure: true`)
3. Trigger a build via API and watch the logs

### Option B — Manual from the Codemagic UI

1. Open the bible app in https://codemagic.io
2. Click **Start new build**
3. Select the **android-play-store-deploy** workflow
4. Pick the `main` branch
5. Click **Start new build**

---

## 4. How tagging works

Push a `v*` tag (e.g. `v1.0.5`) to `main` and Codemagic will automatically
start a build. Use the existing helper:

```bash
./scripts/bump_version.sh 1.0.5
```

This bumps the version in `pubspec.yaml`, commits, tags, and pushes. The tag
push triggers **both**:
- **Codemagic** → builds AAB → uploads to Play Store internal track
- **GitHub Actions** → would build AAB → upload to Play Store (currently
  blocked by the billing lock; will start working again once you fix it)

If both ever run successfully at the same time, the second upload will fail
because the Play Console rejects duplicate `versionCode`s. To avoid this,
disable the GitHub Actions workflow (`.github/workflows/play-store-deploy.yml`
→ "Enable workflow" toggle in the Actions tab) until you decide which CI to
keep long-term.

---

## 5. Cost

- **Free tier**: 500 minutes/month of macOS build time (Linux is unlimited on
  the free tier for open-source repos; private repos get 500 shared minutes).
- A typical Flutter Android AAB build takes 8–15 minutes on a `mac_mini_m2`.
- That's ~30–60 builds per month on the free tier, which should be plenty for
  a release-cadence app like this.
- If you ever exceed 500 min, paid plans start at $75/month for 3000 minutes.

GitHub Actions gives you 2,000 Linux minutes/month for free (private repos),
so the most cost-effective setup long-term is:
- **GitHub Actions** for Android (Linux runners, cheap)
- **Codemagic** for iOS (macOS runners, which GitHub charges 10x for)

But for now, since GitHub Actions is locked, Codemagic handles both.

---

## 6. Security notes

- The Codemagic API token you pasted in chat (`_ysXSX6oEv52k8SQ8…`) is now
  exposed in chat history. **Revoke it** at
  https://codemagic.io/team/settings/api-token once we're done, and create a
  fresh one if you need API access again.
- Codemagic encrypts all environment variables marked "Secure" at rest with
  AES-256. The values are never visible in build logs.
- The `PLAY_SERVICE_ACCOUNT_JSON` variable should be marked **Secure** AND
  **not exposed in logs** (both checkboxes when creating via UI; both flags
  when creating via API).
