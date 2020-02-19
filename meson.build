project (
    'com.github.timecraft.retro',
    'vala', 'c',
    version: '0.0.1'
)

# GNOME and i18n
gnome = import ('gnome')
i18n = import ('i18n')

asresources = gnome.compile_resources (
    'as-resources', 'data/' + meson.project_name() + '.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

# Arguments
add_global_arguments ('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name ()), language:'c')
add_global_arguments ('-DRETRO_GTK_USE_UNSTABLE_API', language:'c')

vapi_dir = meson.source_root () + 'vapis/event_codes.vapi'
#add_global_arguments ('--vapidir ' + vapi_dir, language:'vala')

# C Compiler
cc = meson.get_compiler ('c')
valac = meson.get_compiler ('vala')

# Executable lives here
subdir ('src')
subdir ('data')
