# Build and Serve Guide ( Holy Bible Web — Flutter Web )

Purpose
- Provide a fast, repeatable way to build and serve the Flutter Web version of the app using wasm, with a robust loading experience at launch.

What changed
- web/index.html: Added a lightweight loading overlay and preconnect hints to speed up font loading; base href corrected.
- scripts/build_web.sh: New script to build Flutter Web artifacts with wasm and minimal icon tree-shaking.
- scripts/serve_web.sh: New script to serve the built web app locally with CORS enabled.
- build workflow docs: This guide documents how to use the new scripts and what to expect.

Quick start
- Build:
  bash scripts/build_web.sh
  This will fetch dependencies, build the web assets, and print the build size.
- Serve:
  bash scripts/serve_web.sh
  This will start http-server on port 8080. Open http://localhost:8080.
- Compile and serve in one go (optional):
  bash scripts/build_web.sh && bash scripts/serve_web.sh

Notes
- The wasm build is generally faster to load than the canvas-kit heavy alternative.
- If port 8080 is in use, edit serve_web.sh to use another port or kill the conflicting process.
- The loading overlay is designed to disappear automatically after the first Flutter frame loads.

Further improvements (optional)
- Add a CI step to run flutter build web and verify assets exist.
- Extend the guide with more environment-specific tips (CI, macOS/Linux).

End of guide
