project('com.github.neofight.simplerep', 'vala', 'c')

i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()), language:'c')

vala_files = files(
    'src/dialogs/CreateCardDialog.vala',
    'src/dialogs/EditCardDialog.vala',
    'src/model/Card.vala',
    'src/model/Deck.vala',
    'src/widgets/BrowseView.vala',
    'src/widgets/DeckItem.vala',
    'src/widgets/DeckList.vala',
    'src/widgets/DeckStack.vala',
    'src/widgets/DeckView.vala',
    'src/widgets/HeaderBar.vala',
    'src/widgets/MainView.vala',
    'src/widgets/SummaryView.vala',
    'src/Application.vala',
    'src/Database.vala',
    'src/MainWindow.vala',
    'src/ThrottledEvent.vala'
)

executable(
    meson.project_name(),
    vala_files,
    dependencies: [
        dependency('granite'),
        dependency('gtk+-3.0'),
        dependency('sqlite3'),
    ],
    install: true
)

run_target('lint', command : ['io.elementary.vala-lint', '-d', meson.source_root()])

i18n.merge_file(
    input: join_paths('data', meson.project_name() + '.desktop.in'),
    output: meson.project_name() + '.desktop',
    po_dir: join_paths(meson.source_root(), 'po'),
    type: 'desktop',
    install: true,
    install_dir: join_paths(get_option('datadir'), 'applications')
)

i18n.merge_file(
    input: join_paths('data', meson.project_name() + '.appdata.xml.in'),
    output: meson.project_name() + '.appdata.xml',
    po_dir: join_paths(meson.source_root(), 'po'),
    install: true,
    install_dir: join_paths(get_option('datadir'), 'metainfo')
)

subdir('data')
subdir('po')

meson.add_install_script(join_paths('meson', 'post_install.py'))
