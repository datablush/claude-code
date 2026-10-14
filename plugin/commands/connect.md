---
description: Connect this computer to Datablush, so Spec Kit specs sync by themselves (no tokens spent on them)
---

Connect this computer to Datablush for spec syncing.

1. Run this with a 10-minute timeout (it waits while I allow it): `bash "${CLAUDE_PLUGIN_ROOT}/scripts/datablush.sh" login`
2. As soon as it prints the link and the code, show me both: I open the link (it may already be open in my browser), check the code and click Allow.
3. When it says "Connected", tell me that from now on the Spec Kit files you change are sent to Datablush by themselves when you finish, without spending tokens. If it fails or I cancel, say so and stop.
