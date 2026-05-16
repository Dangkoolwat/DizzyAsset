# semble_rs Troubleshooting

Common `semble_rs` issues and the usual fix path.

## 1. No Results

- Broaden the keyword.
- Search by symbol name, not just file name.
- Confirm the repo path is correct.

## 2. Slow Search

- Narrow the directory.
- Reduce the search intent.
- Re-run with the smallest useful scope.

## 3. Index or Process Issues

- Check for stale index state.
- Restart the search flow if the session looks stale.
- Use the CLI fallback only when the MCP path is unavailable.

## 4. Recovery Rule

- For Swift work, keep discovery on `semble_rs search`.
- Use CRG or Serena for analysis when search alone is not enough.
