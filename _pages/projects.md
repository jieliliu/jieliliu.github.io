---
layout: page
title: research
permalink: /research/
description: Research connecting library practice, information equity, and emerging technologies.
nav: true
nav_order: 1
# Template project-card settings retained for future use:
# display_categories: [work, fun]
# horizontal: false
horizontal: false
---

My research brings together library and information science, computational methods, and a commitment to equitable information services. Across these areas, I ask how people seek, exchange, and evaluate information—and how information institutions can respond responsibly.

## Responsible AI in libraries and virtual reference

I study how generative AI and large language models may shape library reference and research services. My published work evaluates gender and racial bias in large-language-model-powered virtual reference. A developing research project will map widely used AI applications in libraries to their underlying technologies and examine their roles in research support. Planned interviews with library administrators and frontline librarians will explore organizational needs, implementation concerns, and responsible-use practices. Because this project is still developing, no findings are reported here yet.

## Equity in library services

My work on virtual reference investigates whether users receive comparable service across perceived gender and racial identities. This research connects empirical evaluation of email reference and AI-supported reference with the professional values of access, fairness, and inclusive service.

## Science communication and misinformation

I examine how scientists communicate with the public on social media and how misinformation circulates during public-health emergencies. This work uses text analysis, topic modeling, and social network analysis to study public engagement with science and interactions among scientists, misinformation spreaders, and other users.

## Online deliberation and information behavior

My research on online discussion considers how question and topic characteristics influence engagement, civility, argumentation, and knowledge exchange. This work informs the design and facilitation of online spaces that support productive participation.

## Methods

I use mixed methods, including content analysis, interviews, surveys, statistical analysis, natural language processing, and social network analysis. My computational toolkit includes Python, R, Stata, SQL, NVivo, and SPSS.

{% comment %}
TEMPLATE PROJECT-CARD LAYOUT RETAINED FOR FUTURE USE.
Uncomment this block and re-enable the projects collection in `_config.yml` when
you have project images, summaries, dates, collaborators, and related links.

<!-- pages/projects.md -->
<div class="projects">
{%- if site.enable_project_categories and page.display_categories %}
  <!-- Display categorized projects -->
  {%- for category in page.display_categories %}
  <h2 class="category">{{ category }}</h2>
  {%- assign categorized_projects = site.projects | where: "category", category -%}
  {%- assign sorted_projects = categorized_projects | sort: "importance" %}
  <!-- Generate cards for each project -->
  {% if page.horizontal -%}
  <div class="container">
    <div class="row row-cols-2">
    {%- for project in sorted_projects -%}
      {% include projects_horizontal.html %}
    {%- endfor %}
    </div>
  </div>
  {%- else -%}
  <div class="grid">
    {%- for project in sorted_projects -%}
      {% include projects.html %}
    {%- endfor %}
  </div>
  {%- endif -%}
  {% endfor %}

{%- else -%}
<!-- Display projects without categories -->
  {%- assign sorted_projects = site.projects | sort: "importance" -%}
  <!-- Generate cards for each project -->
  {% if page.horizontal -%}
  <div class="container">
    <div class="row row-cols-2">
    {%- for project in sorted_projects -%}
      {% include projects_horizontal.html %}
    {%- endfor %}
    </div>
  </div>
  {%- else -%}
  <div class="grid">
    {%- for project in sorted_projects -%}
      {% include projects.html %}
    {%- endfor %}
  </div>
  {%- endif -%}
{%- endif -%}
</div>
{% endcomment %}
