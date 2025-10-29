import fs from "node:fs";
import path from "node:path";

interface Summary {
  filesAdded: string[];
  filesUpdated: string[];
  filesDeleted: string[];
  hunks: number;
  warnings: string[];
}

function summarizePatch(patchText: string, repoRoot = process.cwd()): Summary {
  const lines = patchText.split(/\r?\n/);
  const added: string[] = [];
  const updated: string[] = [];
  const deleted: string[] = [];
  let hunks = 0;
  const warnings: string[] = [];
  let currentFile: string | null = null;
  let mode: "add" | "update" | "delete" | null = null;

  for (const line of lines) {
    if (line.startsWith("*** Add File: ")) {
      currentFile = line.replace("*** Add File: ", "");
      mode = "add";
      added.push(currentFile);
      continue;
    }
    if (line.startsWith("*** Update File: ")) {
      currentFile = line.replace("*** Update File: ", "");
      mode = "update";
      updated.push(currentFile);
      continue;
    }
    if (line.startsWith("*** Delete File: ")) {
      currentFile = line.replace("*** Delete File: ", "");
      mode = "delete";
      deleted.push(currentFile);
      continue;
    }
    if (line.startsWith("@@")) {
      hunks++;
    }
  }

  // Simple drift checks for updates: ensure target files exist; warn if not
  for (const f of updated) {
    const p = path.resolve(repoRoot, f);
    if (!fs.existsSync(p)) warnings.push(`Target missing for update: ${f}`);
  }
  // For deletes: ensure file exists; otherwise warn
  for (const f of deleted) {
    const p = path.resolve(repoRoot, f);
    if (!fs.existsSync(p)) warnings.push(`Delete target not found: ${f}`);
  }

  return { filesAdded: added, filesUpdated: updated, filesDeleted: deleted, hunks, warnings };
}

if (require.main === module) {
  const file = process.argv[2];
  if (!file) {
    console.error("Usage: node index.js <patch-file>");
    process.exit(2);
  }
  const txt = fs.readFileSync(file, "utf8");
  const sum = summarizePatch(txt);
  console.log(`Files: +${sum.filesAdded.length} ~${sum.filesUpdated.length} -${sum.filesDeleted.length}`);
  console.log(`Hunks: ${sum.hunks}`);
  if (sum.warnings.length) {
    console.log("Warnings:");
    for (const w of sum.warnings) console.log(`- ${w}`);
    process.exitCode = 1; // make it visible
  }
}

export { summarizePatch };

