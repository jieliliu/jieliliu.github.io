#!/usr/bin/env bash

set -u

site_dir="${1:-_site}"
failures=0

pass() {
  printf 'PASS: %s\n' "$1"
}

fail() {
  printf 'FAIL: %s\n' "$1"
  failures=$((failures + 1))
}

page_exists() {
  local path="$1"
  local description="$2"
  if test -f "$site_dir/$path"; then
    pass "$description"
  else
    fail "$description"
  fi
}

page_absent() {
  local path="$1"
  local description="$2"
  if test -e "$site_dir/$path"; then
    fail "$description"
  else
    pass "$description"
  fi
}

page_contains() {
  local path="$1"
  local pattern="$2"
  local description="$3"
  if rg -q -- "$pattern" "$site_dir/$path"; then
    pass "$description"
  else
    fail "$description"
  fi
}

page_not_contains() {
  local path="$1"
  local pattern="$2"
  local description="$3"
  if rg -q -- "$pattern" "$site_dir/$path"; then
    fail "$description"
  else
    pass "$description"
  fi
}

page_exists "index.html" "About page was generated"
page_exists "research/index.html" "Research page was generated"
page_exists "publications/index.html" "Publications page was generated"
page_exists "teaching/index.html" "Teaching page was generated"
page_exists "cv/index.html" "CV page was generated"

page_contains "index.html" 'PhD candidate in Information Science' "About page contains Jieli's current role"
page_contains "index.html" '/assets/img/head.png' "About page uses the selected portrait"
page_contains "research/index.html" 'Responsible AI in libraries and virtual reference' "Research page contains the responsible-AI focus"
page_contains "publications/index.html" 'Assessing Gender and Racial Bias' "Publications page renders Jieli's bibliography"
page_contains "cv/index.html" 'PhD Candidate in Information Science' "CV page renders Jieli's education"
page_not_contains "cv/index.html" 'Albert Einstein|University of Zurich|Nobel Prize' "CV page contains no visible template resume"

page_absent "hobbies/index.html" "Unfinished hobbies page is not published"
page_absent "repositories/index.html" "Template repositories page is not published"
page_absent "dropdown/index.html" "Template dropdown page is not published"
page_absent "blog/index.html" "Template blog is not published"
page_absent "news/index.html" "Template news page is not published"
page_absent "website-future-materials.md" "Internal future-materials guide is not published"
page_absent "assets/json/resume.json" "Einstein JSON Resume template is not publicly deployed"
page_absent "assets/pdf/example_pdf.pdf" "Example PDF is not publicly deployed"
page_absent "README.md" "Repository documentation is not publicly deployed"

if (( failures > 0 )); then
  printf '\n%d generated-site check(s) failed.\n' "$failures"
  exit 1
fi

printf '\nAll generated-site checks passed.\n'
