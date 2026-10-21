# Python: pin + hash

```bash
pip install pip-tools
pip-compile --generate-hashes requirements.in -o requirements.txt
pip install --require-hashes -r requirements.txt
```

`requirements.txt` then contains lines like:

```
requests==2.32.3 \
    --hash=sha256:...
```

With `--require-hashes`, a re-uploaded or swapped file fails the install
even if the version number is identical. Same contract as `npm ci`.

Operators, for the slide:

| Meaning | npm | pip |
|---|---|---|
| exactly this | `1.2.3` | `==1.2.3` |
| patch updates | `~1.2.3` | `~=1.2.3` |
| minor updates | `^1.2.3` | `>=1.2.3,<2` |
| anything newer | `>1.2.3` / `*` | `>1.2.3` |
