# Apple App Store Deployment — Setup Guide

This guide walks you through the one-time setup required to ship signed iOS
IPAs of the **Bible** Flutter app to TestFlight (and, after review, the App
Store) via GitHub Actions.

The CI workflow is already wired up at
[`.github/workflows/app-store-deploy.yml`](../.github/workflows/app-store-deploy.yml).
Once the secrets below are configured, pushing a `v*` tag (e.g. `v1.0.5`) to
`main` will automatically build and upload a new release to TestFlight. The
workflow runs on `macos-14` runners provided by GitHub, so you do not need a
Mac yourself.

> **Status check — do you have a paid Apple Developer Program membership?**
> An active $99/year membership at https://developer.apple.com/programs/ is
> required for any of this to work. Without it, none of the certificates,
> profiles, or App Store Connect API keys described below can be created.

---

## 0. Prerequisites checklist

- An active **Apple Developer Program** membership ($99/year).
- A **bundle identifier** registered in your Apple Developer account. The
  current iOS bundle ID in this repo is
  **`com.chunguchama.holybible`** (different from the Android package name
  `com.chama.bible` — that's intentional, iOS and Android can use different
  identifiers; just make sure your Firebase project has both registered).
- A **Mac** for the one-time certificate/provisioning export step. The CI
  builds themselves run on GitHub-hosted macOS runners — you don't need a Mac
  for those.
- A clear idea of where to store the eight secrets this workflow needs.
  Apple's materials here are sensitive; treat them like passwords.

---

## 1. Register the App ID

1. Go to https://developer.apple.com/account/resources/identifiers/list.
2. Click the **+** button.
3. Select **App IDs** → Continue.
4. Description: `Bible`.
5. Bundle ID: **Explicit** → `com.chunguchama.holybible` (must match what's
   in `ios/Runner.xcodeproj/project.pbxproj`).
6. Under **Capabilities**, tick everything your app needs. The current
   `ios/Runner/Info.plist` and the Firebase integration suggest at minimum:
   - **Push Notifications** (if you ever ship push)
   - **Sign in with Apple** (the app uses `sign_in_with_apple`)
7. Continue → Register.

---

## 2. Create a distribution certificate

You need an **Apple Distribution** certificate to sign IPAs for TestFlight /
App Store.

### Easiest path — Xcode on a Mac

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Select the **Runner** target → **Signing & Capabilities** tab.
3. Tick **Automatically manage signing**.
4. Select your Team.
5. Xcode will create the certificate and provisioning profile for you. Verify
   there are no errors next to "Signing Certificate".

### Export the certificate as a .p12 (for CI)

1. Open **Keychain Access** on the Mac where Xcode created the cert.
2. Find the certificate named **iPhone Distribution: \<Your Name\>
   (\<TEAM_ID\>)** under the **My Certificates** category.
3. Right-click → **Export…**
4. Save as `bible-distribution.p12`, choose a strong password, save.
5. You'll need this password and the .p12 file in step 7.

### Manual path (no Mac available)

If you don't have a Mac, you can create the certificate via the Apple
Developer portal directly:

1. https://developer.apple.com/account/resources/certificates/list → **+**.
2. Choose **Apple Distribution** → Continue.
3. Upload a Certificate Signing Request (CSR) generated via `openssl` on any
   platform (instructions on the page).
4. Download the resulting `.cer` file.
5. Convert to .p12 with `openssl` — see
   https://developer.apple.com/documentation/security/certificate_key_and_trust_services/helper_tools
   for the exact commands.

---

## 3. Create a provisioning profile

1. https://developer.apple.com/account/resources/profiles/list → **+**.
2. Choose **App Store** under Distribution → Continue.
3. Select the App ID you created in step 1 → Continue.
4. Select the distribution certificate from step 2 → Continue.
5. Profile name: `Bible AppStore Distribution`.
6. Generate → Download the `.mobileprovision` file.

---

## 4. Create an App Store Connect API key

The CI workflow authenticates to App Store Connect using an API key rather
than your Apple ID (which would require 2FA — incompatible with CI).

1. Go to https://appstoreconnect.apple.com/access/integrations/api.
2. Click **Generate API Key** (or **+ Create** if you already have one).
3. Name: `GitHub Actions Bible Deploy`.
4. Access: **Admin** (or **App Manager** if you want to limit scope — Admin
   is simpler and required for `xcrun altool --upload-app`).
5. Click **Generate**.

You will see three values you need to capture **immediately**:

| Value | Where it goes |
| --- | --- |
| **Issuer ID** (a UUID shown at the top of the page, same for all your keys) | `APPSTORE_API_ISSUER_ID` GitHub secret |
| **Key ID** (10 chars, e.g. `ABC1234XYZ`) | `APPSTORE_API_KEY_ID` GitHub secret |
| **Download API Key** link (a `.p8` file — **only downloadable once!**) | base64-encode and store as `APPSTORE_API_KEY_P8_BASE64` GitHub secret |

> ⚠️ **The .p8 file is only downloadable once.** If you lose it, you must
> revoke the key and create a new one. Save it somewhere permanent (password
> manager, encrypted volume).

---

## 5. Create the app in App Store Connect

1. Go to https://appstoreconnect.apple.com/apps.
2. Click the **+** button → **New App**.
3. Fill in:
   - **Platforms**: iOS.
   - **Name**: `Holy Bible – Divine Word` (must be unique on the App Store;
     `Holy Bible` alone will likely be taken).
   - **Primary Language**: English (U.S.).
   - **Bundle ID**: `com.chunguchama.holybible` (the one from step 1).
   - **SKU**: `bible-app` (internal identifier, not shown to users).
   - **User Access**: Full Access.
4. Click **Create**.
5. Fill out the App Information, Pricing, and App Store listing tabs at your
   leisure — they're not required for TestFlight uploads, only for App Store
   submission.

---

## 6. Prepare the secrets

On your local machine, encode each binary asset as base64 and copy the
output:

```bash
# Distribution .p12 → base64
base64 -i bible-distribution.p12 | pbcopy    # macOS
# or:  base64 -w 0 bible-distribution.p12    # Linux

# Provisioning profile → base64
base64 -i "Bible AppStore Distribution.mobileprovision" | pbcopy

# App Store Connect API key .p8 → base64
base64 -i AuthKey_ABC1234XYZ.p8 | pbcopy
```

Also locate your **Team ID** (10-character identifier shown at
https://developer.apple.com/account#MembershipDetailsCard — looks like
`A1B2C3D4E5`).

---

## 7. Add secrets to GitHub

Open the repo on GitHub: **Settings → Secrets and variables → Actions → New
repository secret**. Add the following eight secrets:

| Secret name | Value |
| --- | --- |
| `APPSTORE_API_KEY_ID` | The Key ID from step 4 (10 chars, e.g. `ABC1234XYZ`). |
| `APPSTORE_API_ISSUER_ID` | The Issuer ID UUID from step 4. |
| `APPSTORE_API_KEY_P8_BASE64` | base64-encoded contents of the `AuthKey_<ID>.p8` file. |
| `IOS_CERTIFICATE_P12_BASE64` | base64-encoded contents of the distribution `.p12` file. |
| `IOS_CERTIFICATE_PASSWORD` | The password you set when exporting the .p12. |
| `IOS_PROVISIONING_PROFILE_BASE64` | base64-encoded contents of the `.mobileprovision` file. |
| `IOS_TEAM_ID` | Your Apple Developer Team ID (10 chars). |
| `IOS_BUNDLE_ID` | `com.chunguchama.holybible` (matches the Xcode project). |

Also add an optional **repository variable** (Settings → Secrets and
variables → Actions → **Variables** tab → New repository variable):

| Variable name | Default | Notes |
| --- | --- | --- |
| `IOS_SCHEME` | `Runner` | Override if you renamed the Xcode scheme. |
| `IOS_EXPORT_METHOD` | `app-store` | `app-store` for TestFlight / App Store. Switch to `ad-hoc` / `development` for non-store builds. |

---

## 8. Trigger your first deployment

### Option A — Smoke test (recommended first run)

1. Go to **Actions → Deploy to App Store (TestFlight) → Run workflow**.
2. Tick **"Build the IPA but skip the TestFlight upload"**.
3. Click **Run workflow**.
4. The workflow will build the IPA and upload it as a workflow artifact
   (under the run summary). Download it and verify the file exists and is
   roughly the size you expect (~20–60 MB for a Flutter app).
5. If the build fails, common issues are:
   - Certificate / provisioning profile mismatch (most common). Re-verify
     that the App ID in the profile matches `IOS_BUNDLE_ID`.
   - Pod install failure. Re-run `pod install` locally and commit the
     updated `Podfile.lock`.
   - Code signing "no profiles for … were found" — the provisioning profile
     wasn't installed correctly in CI. Check the "Install provisioning
     profile" step's log.

### Option B — Real upload via tag

Use the same `bump_version.sh` script as for Android — it tags `v*`, which
triggers **both** the Play Store and App Store workflows in parallel:

```bash
./scripts/bump_version.sh 1.0.1
```

Watch the runs under **Actions**. On success, the new build appears under
**TestFlight** in App Store Connect within a few minutes (Apple's processing
can take 10–30 minutes before the build is available to internal testers).

---

## 9. TestFlight internal testers

Once the first build lands in TestFlight:

1. In App Store Connect, go to your app → **TestFlight** tab.
2. Under **Internal testers** (top-right), click **+** and add yourself by
   Apple ID. Internal testers are pulled from your App Store Connect user
   list and don't need to accept an invite.
3. Wait for Apple to process the build (~10–30 min). Status changes from
   "Processing" to "Available for testing".
4. On your iPhone, install the **TestFlight** app from the App Store.
5. Open the invite email on your iPhone and tap **View in TestFlight** →
   **Install**.

For **external testers** (people who aren't on your App Store Connect team),
you need to fill out the **Test Information** form (privacy policy URL,
review notes, etc.) and submit for a quick Apple beta review (~24–48 hours
for the first build, faster afterwards).

---

## 10. App Store submission

TestFlight is for testing. To ship to the actual App Store:

1. In App Store Connect → your app → **App Store** tab.
2. Fill out all required listing fields: screenshots, description, keywords,
   support URL, marketing URL, privacy policy URL.
3. Under **Build**, select the latest approved TestFlight build.
4. Click **Submit for Review**.
5. Apple's review typically takes 24–48 hours for the first submission.

---

## 11. Troubleshooting

| Symptom | Likely cause / fix |
| --- | --- |
| `xcrun altool: Unable to authenticate` | API key expired or revoked. Regenerate at App Store Connect → Users and Access → Keys. |
| `no provisioning profile matching ... was found` | Bundle ID in profile doesn't match `IOS_BUNDLE_ID` secret. Or the profile is for a different certificate. |
| `security: SecKeychainItemImport: MAC verification failed` | `IOS_CERTIFICATE_PASSWORD` is wrong. Re-export the .p12 with a known password. |
| `xcodebuild: Code signing error: Provisioning profile "…" doesn't include signing certificate` | Certificate and profile out of sync. Regenerate the profile against the current certificate. |
| `pod install` fails with version conflict | Run `pod install --repo-update` locally, commit the new `Podfile.lock`. |
| Build succeeds but TestFlight shows "Invalid Swift Support" | Usually caused by an outdated Flutter or Xcode. The CI uses the latest `macos-14` runner, which ships current Xcode. If you're building locally with old Xcode, the IPA won't be accepted. |
| Build fails with "marketing version / build number" errors | The workflow auto-sets these from `pubspec.yaml`. Make sure `version: NAME+CODE` is well-formed. |
| Build fails after the Android one succeeds | The two workflows are independent. iOS failures don't affect Android and vice versa. |

---

## 12. Security notes

- The `APPSTORE_API_KEY_P8_BASE64` secret grants **Admin** access to your
  App Store Connect account. Treat the repo's secret scope accordingly — do
  not make the repo public, and review collaborator access.
- The `.p12` distribution certificate + password together can sign any app
  for your developer team. Treat them as you would a code-signing root key.
- The `.mobileprovision` file embeds the certificate and is tied to a
  specific bundle ID. Less sensitive than the .p12, but still keep it
  private.
- If a secret leaks (e.g. printed in a log), rotate it: revoke the API key
  in App Store Connect, revoke the certificate in the Apple Developer
  portal (which also invalidates the profile), and re-export a fresh .p12.
