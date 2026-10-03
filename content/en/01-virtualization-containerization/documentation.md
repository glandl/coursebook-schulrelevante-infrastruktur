+++
title = "Documentation task"
weight = 50
+++

{{% callout style="info" title="Technique" %}}
First read in the documentation script: [Markdown, Git and pull request workflow]({{% relref "/00-documentation/markdown-git" %}})
{{% /callout %}}

## Task in this session

Document your lab as a **portfolio entry** (mandatory submission, assessed with the [rubric]({{% relref "/rubric" %}})). This is **not** the homework, but the proof of your lab work.

**Location:** `01-virtualization-containerization/README.md` with images in `assets/`, branch `session-01`, submission via pull request.

### Content

1. **Environment:** host operating system, RAM, VirtualBox/UTM version, Ubuntu version, Docker version.
2. **Procedure** with all important steps (commands as code blocks, not as screenshots):
   - VM created (settings),
   - snapshot created and restored,
   - Docker installed,
   - Nextcloud (or nginx) started with Compose,
   - backup and restore carried out.
3. **Result:** At least **four screenshots** following the [conventions]({{% relref "/00-documentation/markdown-git" %}}): VM settings, snapshot list, `docker compose ps`, web interface. No passwords, no real names.
4. **Problems and solutions:** At least one problem that occurred, with cause and solution (even if it was small).
5. **Reflection (school context), approx. 150–200 words:** Would you use this solution at a school? What would be the biggest stumbling block (support, data protection, backups)?
6. **Sources:** Guides and documentation used.

### Submission

- Pull request to `main` using the PR template from the documentation script.
- Deadline: together with the homework on **18.10.2026** (the day before session 2). _The final deadline for the portfolio will be confirmed in the session._

### Checklist

- [ ] README follows the template (goal, procedure, result, problems, reflection, sources).
- [ ] Commands are copyable (code blocks).
- [ ] Screenshots in `assets/`, sensibly named, with alt text.
- [ ] No passwords, `.env` files or personal data.
- [ ] At least three meaningful commits with informative messages.
- [ ] Pull request opened, reviewer added.
