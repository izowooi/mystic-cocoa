find /Users/izowooi/Library/CloudStorage/OneDrive-개인/Project/MysticCocoa/major_arcana -depth -type d -name '*-*' | while read dir; do
    mv "$dir" "$(dirname "$dir")/$(basename "$dir" | tr '-' '_')"
done
