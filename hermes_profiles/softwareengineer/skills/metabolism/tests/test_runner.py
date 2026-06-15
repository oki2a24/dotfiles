import sys
import os
import importlib
from pathlib import Path

# 1. Add current directory and .hermes_profiles to sys.path
# We treat .hermes_profiles as hermes_profiles for imports
ROOT = Path(__file__).resolve().parents[4] # Adjust based on where this is placed
HERMES_DIR = ROOT / ".hermes_profiles"

# Add the root (to find .hermes_profiles) and the hidden directory itself
# if it were named correctly, but we will use a more direct approach.
sys.path.append(str(ROOT))
sys.path.append(str(HERMES_DIR))

# 2. Mapping for the hyphenated directory: software-engineer -> software_engineer
# We'll inject this into sys.modules to allow 'import hermes_profiles.softwareengineer'
# when the folder is actually '.hermes_profiles/software-engineer'

class HyphenRedirect(importlib.abc.MetaPathImporter):
    def find_spec(self, fullname, path, target=None):
        if fullname == "hermes_profiles.softwareengineer":
            # We want to redirect this to .hermes_profiles/software-engineer
            # This is complex. Let's try a simpler way first:
            # Just symlink the directory in a temporary location if possible.
            pass
        return None

# Actually, let's just create a local package structure for testing.
