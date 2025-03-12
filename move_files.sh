#!/bin/bash

# Create necessary directories
mkdir -p lib/presentation/pages
mkdir -p lib/presentation/widgets

# Move widgets to presentation/widgets
mv lib/widgets/common_app_bar.dart lib/presentation/widgets/ 2>/dev/null
mv lib/widgets/group_card.dart lib/presentation/widgets/ 2>/dev/null
mv lib/widgets/theme_switcher.dart lib/presentation/widgets/ 2>/dev/null

# Move pages to presentation/pages
mv lib/pages/group_details_page.dart lib/presentation/pages/ 2>/dev/null
mv lib/pages/group_management_page.dart lib/presentation/pages/ 2>/dev/null
mv lib/pages/home_page.dart lib/presentation/pages/ 2>/dev/null

echo "Files moved successfully!"