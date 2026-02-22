# Shared helpers for create-nix-package scripts

spdx_to_nix() {
  case "$1" in
    MIT) echo "licenses.mit" ;;
    Apache-2.0) echo "licenses.asl20" ;;
    GPL-2.0 | GPL-2.0-only) echo "licenses.gpl2Only" ;;
    GPL-2.0-or-later) echo "licenses.gpl2Plus" ;;
    GPL-3.0 | GPL-3.0-only) echo "licenses.gpl3Only" ;;
    GPL-3.0-or-later) echo "licenses.gpl3Plus" ;;
    BSD-2-Clause) echo "licenses.bsd2" ;;
    BSD-3-Clause) echo "licenses.bsd3" ;;
    ISC) echo "licenses.isc" ;;
    MPL-2.0) echo "licenses.mpl20" ;;
    LGPL-2.1 | LGPL-2.1-only) echo "licenses.lgpl21Only" ;;
    LGPL-2.1-or-later) echo "licenses.lgpl21Plus" ;;
    LGPL-3.0 | LGPL-3.0-only) echo "licenses.lgpl3Only" ;;
    LGPL-3.0-or-later) echo "licenses.lgpl3Plus" ;;
    AGPL-3.0 | AGPL-3.0-only) echo "licenses.agpl3Only" ;;
    AGPL-3.0-or-later) echo "licenses.agpl3Plus" ;;
    Unlicense) echo "licenses.unlicense" ;;
    0BSD) echo "licenses.bsd0" ;;
    *) echo "licenses.unfree  # TODO: verify license ($1)" ;;
  esac
}

# Replace version string in asset name with a placeholder.
# Requires $VERSION to be set in the calling scope.
# $1: asset name  $2: placeholder (e.g. '${version}' or '${LATEST}')
version_template() {
  local escaped_ver
  escaped_ver=$(printf '%s\n' "$VERSION" | sed 's/[.+*?^${}()|[\]\\]/\\&/g')
  echo "$1" | sed "s/$escaped_ver/$2/g"
}
