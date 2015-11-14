use_frameworks!

pod 'FoldingTabBar', '~> 1.0.1'
pod 'Koloda', '~> 1.1.2'
post_install do |installer|
    `find Pods -regex 'Pods/pop.*\\.h' -print0 | xargs -0 sed -i '' 's/\\(<\\)pop\\/\\(.*\\)\\(>\\)/\\"\\2\\"/'`
end