---
name: run-log
description: >-
  Create and maintain a self-contained HTML "run log" that tracks long-running
  jobs or experiments — training runs, batch scripts, data-processing jobs,
  benchmarks, anything you launch and wait on. One collapsible entry per run
  with status, the exact command, a link to where it is monitored, notes, and
  an optional results table. Use when the user wants to record, track, or
  report runs/experiments in a portable, shareable log.
---

# Run log

Maintain a single self-contained HTML file that logs a series of runs — one
collapsible `<details>` entry per run. It is plain HTML with inline CSS so it
opens in any browser and can be shared as a file or committed to a repo. It is
deliberately domain-agnostic: a "run" can be a training job, a batch script, a
data pipeline, a benchmark sweep, etc.

## Files in this skill

- `assets/template.html` — starting point for a new log. Copy it to wherever the
  log should live (e.g. `RUN_LOG.html` in the working directory).

Reference it relative to this skill's own directory.

## Starting a new log

Copy `assets/template.html` to the target path and edit the `<h1>` title and the
meta header. If a log already exists, append to it instead of overwriting.

## Adding a run (when a run is launched)

Insert one `<details>` block per run, immediately before `</body>`:

```html
<details>
  <summary>SHORT ONE-LINE TITLE</summary>
  <h2>Status</h2>
  <p class="running">Running. Started: &lt;ISO-8601 UTC&gt;.</p>
  <h2>Command</h2>
  <pre><code>THE EXACT COMMAND USED TO LAUNCH THE RUN</code></pre>
  <h2>Link</h2>
  <p><a href="URL">where this run is monitored (dashboard / console / log file)</a></p>
  <h2>Notes</h2>
  <p>What this run is and why. Record enough to reproduce it: version / commit /
  image / environment, plus any validation done before launch. If it is a
  variant, say what changed versus the baseline.</p>
  <h2>Results</h2>
  <p class="pending">Pending while the run is in progress.</p>
</details>
```

### Status lifecycle

Set the CSS status class on the Status `<p>`:

- `pending` — queued / not started
- `running` — in progress; record the start time
- `complete` — succeeded; record start, finish, and duration
- `failed` — failed; record what happened and link to logs

### When the run finishes

Flip the Status line to `complete` (or `failed`) with finish time + duration,
then fill in Results:

1. A one-line summary — output location, headline metric/total, pass/fail.
2. If there is tabular output (per-bucket counts, per-metric scores, per-epoch
   numbers…), read the run's own result file (yaml / json / csv / log) and render
   the rows you care about as an HTML `<table>` (bold any rows worth highlighting):

   ```html
   <table>
     <tr><th>Item</th><th>value</th></tr>
     <tr><td><code>example_row</code></td><td>1,234</td></tr>
   </table>
   ```

## Conventions

- Keep the log self-contained — no external CSS/JS, one file, opens offline.
- Paste commands verbatim and in full. The template wraps long lines, so never
  truncate a command to avoid horizontal scrolling.
- Prefer absolute, copy-pasteable commands and links.
- One entry per run; append, never overwrite a previous run's entry.
- Record reproducibility details in Notes (commit / version / image / env) so an
  entry is meaningful long after the run.
