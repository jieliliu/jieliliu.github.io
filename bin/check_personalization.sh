#!/usr/bin/env bash

set -u

project_dir="${1:-.}"
failures=0

pass() {
  printf 'PASS: %s\n' "$1"
}

fail() {
  printf 'FAIL: %s\n' "$1"
  failures=$((failures + 1))
}

contains() {
  local file="$1"
  local pattern="$2"
  local description="$3"

  if rg -q -- "$pattern" "$project_dir/$file"; then
    pass "$description"
  else
    fail "$description"
  fi
}

not_contains() {
  local file="$1"
  local pattern="$2"
  local description="$3"

  if rg -q -- "$pattern" "$project_dir/$file"; then
    fail "$description"
  else
    pass "$description"
  fi
}

not_contains_active() {
  local file="$1"
  local pattern="$2"
  local description="$3"

  if sed -e '/^[[:space:]]*#/d' -e '/^[[:space:]]*%/d' "$project_dir/$file" | rg -q -- "$pattern"; then
    fail "$description"
  else
    pass "$description"
  fi
}

contains "_config.yml" '^scholar_userid: YCm5exUAAAAJ$' "Google Scholar profile is configured"
contains "_config.yml" '^  last_name: \[Liu\]$' "Jekyll Scholar highlights Jieli Liu"
contains "_pages/about.md" 'PhD candidate in Information Science' "About page states current academic role"
not_contains "_pages/about.md" 'Affiliations|third year PhD student|Moto\. Etc' "About page has no visible template biography"
contains "_pages/projects.md" '^title: research$' "Projects template is repurposed as Research"
contains "_pages/teaching.md" 'Resources and Services for People with Disabilities' "Teaching page contains current course information"
not_contains "_pages/teaching.md" 'For now, this page is assumed' "Teaching page has no visible template instructions"
contains "_pages/cv.md" 'Academic background, professional experience, teaching, service, honors, and skills' "CV page has a useful description"
contains "_config.yml" '^jekyll_get_json: \[\]$' "Einstein JSON Resume template is disabled"
not_contains_active "_data/cv.yml" 'Albert Einstein|University of Zurich|Nobel Prize' "CV data contains no active Einstein template content"
contains "_bibliography/papers.bib" 'doi = \{10\.1002/pra2\.1061\}' "LLM virtual-reference publication is present"
contains "_bibliography/papers.bib" 'doi = \{10\.1108/RSR-05-2023-0051\}' "Email-reference publication is present"
not_contains_active "_bibliography/papers.bib" 'Einstein|Brownian Movement|PhysRev\.47\.777' "Bibliography contains no active Einstein template records"
contains "_bibliography/template-papers.bib.txt" 'Albert Einstein|Einstein, Albert' "Original bibliography template is preserved outside the active BibTeX data"
contains "_pages/repositories.md" '^nav: false$' "Repositories template is hidden from navigation"
contains "_pages/dropdown.md" '^nav: false$' "Dropdown template is hidden from navigation"
contains "_pages/hobbies.md" '^nav: false$' "Hobbies page exists and is hidden"
contains "_config.yml" '^blog_nav_title:$' "Sample blog is hidden from navigation"
contains "_config.yml" '^  enabled: false$' "Sample news or posts are disabled"
contains "blog/index.html" '^published: false$' "Sample blog index is not published"
contains "news.html" '^published: false$' "Sample news index is not published"
contains "_config.yml" '^  - assets/jupyter$' "Template notebook is preserved but excluded from builds"
contains "_config.yml" '^  - website-future-materials\.md$' "Internal future-materials guide is excluded from the public site"
not_contains "_config.yml" '^  - assets/pdf$' "Future CV PDFs remain deployable"
contains "_config.yml" '^  - assets/pdf/example_pdf\.pdf$' "Only the sample PDF is excluded"
contains "website-future-materials.md" '^# Website: Future Materials and Suggestions$' "Future-materials guide exists"

if (( failures > 0 )); then
  printf '\n%d personalization check(s) failed.\n' "$failures"
  exit 1
fi

printf '\nAll personalization checks passed.\n'
