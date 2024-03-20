# App-specific zkOracle Framework

Prove real-world data, processes and operations with Usher Labs, and then verify with a zkOracle.

## Dev Env Synchronisation

Operating the ZK Prover on a local machine may not be viable.
To synchronise your local directory to a remote server, leverage the `devsync.sh`.

- **For MacOS**
  1. Install `inotify-tools` - ie. `brew install inotify-tools`
  2. Run `./bin/devsync.sh` from the root directory.