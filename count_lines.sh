#!/bin/bash

echo "📊 Counting lines of code..."

# ignore.git, node_modules, Pods 等
EXCLUDED_DIRS="(.git|node_modules|Pods|.build|.idea|.vscode)"

# calculate
LINES=$(find . -type f \
  -not -path "./$EXCLUDED_DIRS/*" \
  -name "*.swift" -or -name "*.js" -or -name "*.ts" -or -name "*.py" -or -name "*.java" \
  | xargs wc -l \
  | tail -n1 \
  | awk '{print $1}')

# output
echo "🧮 **Total lines of code:** \`$LINES\`" > code_stats.md
