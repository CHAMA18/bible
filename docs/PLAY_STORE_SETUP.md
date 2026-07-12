# Google Play Store Deployment — Setup Guide

This guide walks you through the one-time setup required to ship signed Android
App Bundles (AABs) of the **Bible** Flutter app to the Google Play Store via
GitHub Actions.

The CI workflow is already wired up at
[`.github/workflows/play-store-deploy.yml`](../.github/workflows/play-store-deploy.yml).
Once the secrets below are configured, pushing a `v*` tag (e.g. `v1.0.5`) to
`main` will automatically build and upload a new release to the Play Console
internal track. You can also trigger the workflow manually from the
**Actions** tab and pick a different track (`internal`, `alpha`, `beta`,
`production`) or run a smoke-test build that skips the upload.

---

## 0. Prerequisites checklist

- A **Google Play Console** account with an active **$25 one-time developer
  registration** (https://play.google.com/console/signup).
- A **Google Cloud** project (can be the same one Firebase is using).
- A **local machine** with `keytool` installed (any JDK works — Android Studio
  bundles one).
- A clear idea of your **final application ID** (package name), e.g.
  `com.chunguchama.bible`. **Do not use the current placeholder
  `com.mycompany.CounterApp` for production.** See step 7 below.

---

## 1. Generate a release keystore (local machine, one-time)

The keystore signs every AAB you upload. **If you lose it, you cannot publish
updates to the same Play Store listing ever again** — back it up to at least
two secure locations (password manager, encrypted USB, etc.).

```bash
cd path/to/bible
./scripts/generate_keystore.sh
```

The script will:

1. Prompt you for a keystore store password and a key password (both ≥ 6
   characters). **Write these down** — you'll paste them into GitHub secrets
   in step 6.
2. Prompt for distinguished-name fields (your name, organisation, city, etc.).
3. Produce `bible-release.jks` and a `bible-release.jks.base64` file in the
   repo root.

Both files are gitignored — verify with `git status` that they are **not**
about to be committed.

---

## 2. Create the app in Google Play Console

1. Sign in to https://play.google.com/console.
2. Click **Create app**.
3. Fill in:
   - **App name**: `Holy Bible – Divine Word & Devotions` (or whatever you want
     displayed on the Store listing).
   - **Default language**: English (United States) (or your preference).
   - **App type**: Application.
   - **Pricing**: Free.
4. Accept the declarations and click **Create app**.
5. In the left sidebar, go to **Setup → App access** and answer the questions.
6. Go to **Setup → App integrity**. **This is where Play generates the app
   signing key for you** (Play App Signing). Choose **"Use a generated key"**.
   You'll need to upload your first AAB before this fully completes — that's
   fine, the first upload will trigger it.

> ⚠️ The **package name** shown in **Setup → App integrity → App signing key
> management** must match the `applicationId` in `android/app/build.gradle`.
> If the current placeholder `com.mycompany.CounterApp` is unacceptable for
> production (it almost certainly is), change it **now** — see step 7.

---

## 3. Create the app in Google Play Console (continued)

Fill out the **Store listing** (Main store listing → App details): icon, feature
graphic, screenshots, short/long description, etc. You can return to this
later, but the first upload to the internal track requires the listing to
clear all **required** fields.

---

## 4. Create a Google Cloud service account

The Play Console does not let you log in with email + password for automated
uploads. Instead, you create a **service account** in Google Cloud and invite
it to your Play Console with **Admin** (or at least **Create & publish
releases**) permissions.

1. Go to the Google Cloud Console:
   https://console.cloud.google.com/iam-admin/serviceaccounts.
2. Select the project your Play Console / Firebase project is associated with.
3. Click **Create service account**.
   - Name: `play-store-deployer`
   - ID: auto-generated is fine.
   - Description: `Used by GitHub Actions to upload AABs to Play Console.`
4. Click **Create and continue**.
5. **Skip the optional role grant** — the service account does not need any
   Google Cloud roles. Click **Done**.
6. Click into the new service account → **Keys** tab → **Add key → Create new
   key** → choose **JSON** → **Create**.
7. A `play-service-account-*.json` file will download. **Keep it safe and
   never commit it** — it's gitignored under `service-account-*.json` in this
   repo.

---

## 5. Invite the service account to your Play Console

1. Open the downloaded JSON file. Copy the `client_email` value — it looks like
   `play-store-deployer@your-project.iam.gserviceaccount.com`.
2. Go to https://play.google.com/console → **Users and permissions → Invite
   users**.
3. Paste the service account email.
4. Under **App permissions**, choose the Bible app you created in step 2.
5. Grant the **Admin** role (or at minimum: **Create & publish releases** to
   all tracks you intend to deploy to).
6. Send invite. The account appears immediately in the user list with type
   "Service account".

---

## 6. Add secrets to GitHub

Open the repo on GitHub: **Settings → Secrets and variables → Actions → New
repository secret**. Add the following five secrets:

| Secret name | Value |
| --- | --- |
| `KEYSTORE_BASE64` | The full contents of `bible-release.jks.base64` (one long string). |
| `KEYSTORE_ALIAS` | `bible-key` (the default alias from `generate_keystore.sh`). |
| `KEYSTORE_PASSWORD` | The store password you typed when running the script. |
| `KEY_PASSWORD` | The key password you typed when running the script. |
| `PLAY_SERVICE_ACCOUNT_JSON` | The full contents of the `play-service-account-*.json` file downloaded in step 4. Paste it as-is — GitHub will treat it as a single string. |

Also add an optional **repository variable** (Settings → Secrets and
variables → Actions → **Variables** tab → New repository variable):

| Variable name | Value |
| --- | --- |
| `PLAY_PACKAGE_NAME` | Your final `applicationId` (e.g. `com.chunguchama.bible`). If you don't set this, the workflow falls back to `com.mycompany.CounterApp` from the gradle file. |

After adding the secrets, **delete the local base64 file** so it cannot be
leaked from your dev machine:

```bash
rm bible-release.jks.base64
```

Keep `bible-release.jks` itself in a safe offline location (e.g. an encrypted
volume) — you will need it again only if you ever rebuild on a different
machine or rotate the key.

---

## 7. Finalise the Android `applicationId` (if you haven't already)

The current `android/app/build.gradle` contains the Flutter template
placeholder:

```gradle
applicationId = "com.mycompany.CounterApp"
```

Before your first real upload, change this to your final package name (e.g.
`com.chunguchama.bible`). **This change has ripple effects**:

1. **Firebase** — the `android/app/google-services.json` in this repo was
   generated for the old package name. After changing `applicationId`, you
   must:
   - Go to https://console.firebase.google.com → your project → Project
     settings → Android apps.
   - Add a new Android app with the new package name.
   - Download the new `google-services.json` and overwrite the one at
     `android/app/google-services.json`.
2. **Play Console** — the app you created in step 2 must use the same package
   name. If you already created it with the old name, you can't rename — you'd
   have to delete it and recreate. Do this **before** creating the Play
   Console app.
3. **Workflow** — either update `PLAY_PACKAGE_NAME` (recommended) or change
   the fallback in `.github/workflows/play-store-deploy.yml`.

---

## 8. Bump the version before each release

The Flutter version lives in `pubspec.yaml`:

```yaml
version: 1.0.0+4
```

Format is `versionName+versionCode`. **Both must increase** on every upload to
Play Store — Play rejects any AAB whose `versionCode` is ≤ a previously
uploaded one.

- `1.0.0` → `versionName` (shown to users on the Store listing).
- `4` → `versionCode` (integer, must monotonically increase).

Bump both before tagging. Example: `1.0.0+4` → `1.0.1+5`.

---

## 9. Trigger your first deployment

### Option A — Smoke test (recommended first run)

1. Go to **Actions → Deploy to Google Play Store → Run workflow**.
2. Pick `track: internal` and tick **"Build the AAB but skip the Play Store
   upload"**.
3. Click **Run workflow**.
4. The workflow will build the AAB and upload it as a workflow artifact (under
   the run summary). Download it and verify the file exists and is roughly the
   size you expect (~10–25 MB for a Flutter app).
5. If the build fails, check the logs — common issues are Java version
   mismatches or stale `pubspec.lock`.

### Option B — Real upload via tag

1. Update `pubspec.yaml` version (e.g. `1.0.0+4` → `1.0.1+5`).
2. Commit:
   ```bash
   git commit -am "chore(release): v1.0.1"
   ```
3. Tag and push:
   ```bash
   git tag v1.0.1
   git push origin main v1.0.1
   ```
4. Watch the run at **Actions → Deploy to Google Play Store**. On success,
   the new release will appear under **Internal testing** in the Play Console
   (or whichever track you configured).

### Option C — Manual upload (no GitHub Actions)

If you just want to upload a single AAB once, build it locally:

```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

Then drag-and-drop that file into **Play Console → Internal testing → Create
new release**. You still need a release keystore — either use
`./scripts/generate_keystore.sh` and configure `android/key.properties`, or
let Play generate the signing key for you (Play App Signing) on first upload.

---

## 10. Troubleshooting

| Symptom | Likely cause / fix |
| --- | --- |
| `403: The current user has insufficient permissions to perform the requested operation` | Service account not invited to the Play Console, or doesn't have release permissions on the right app. Re-do step 5. |
| `User does not have sufficient permissions for package` | `PLAY_PACKAGE_NAME` (or the fallback in the workflow) does not match the app's actual package in Play Console. |
| `404: Package not found` | The service account was invited, but to a different app. Confirm in Play Console → Users and permissions. |
| AAB upload succeeds but Play rejects with `versionCode already used` | Bump `versionCode` in `pubspec.yaml` and re-tag. |
| Build fails with `Keystore file not set for signing config release` | `android/key.properties` not being generated — check the "Decode release keystore" step's log. |
| `keytool: command not found` locally | Install any JDK (`brew install openjdk` / `apt install default-jdk`) or use Android Studio's bundled one. |
| Build fails with Java version mismatch | Workflow already pins Java 17. If your local build fails, run with `JAVA_HOME` pointing at JDK 17. |
| First upload prompts for app signing key | Accept **"Use a generated key"** so Google manages your app signing key. Your upload key (the one in `bible-release.jks`) stays with you; Google uses it to verify your uploads and re-signs with their key for distribution. |

---

## 11. Security notes

- **Never commit** `bible-release.jks`, `key.properties`, or any
  `service-account-*.json` file. They are all gitignored — but always verify
  with `git status` before pushing.
- The `PLAY_SERVICE_ACCOUNT_JSON` GitHub secret grants full release management
  on your Play Console app. Treat the repo's secret scope accordingly — do not
  make the repo public, and review collaborator access.
- If a secret is leaked (e.g. accidentally printed in a log), rotate it:
  revoke the service account key in Google Cloud Console, generate a new one,
  and update the GitHub secret. For the keystore, you'd need to contact Play
  Console support to reset app signing — avoid this scenario at all costs by
  backing up the keystore properly.
