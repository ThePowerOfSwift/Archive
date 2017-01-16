require_relative 'utils.rb'

# TODO: refactor, loop

def create_carthage_script_phase_for_target(target)
    script_phase = target.new_shell_script_build_phase
    script_phase.shell_script = '/usr/local/bin/carthage copy-frameworks'
    return script_phase
end

# platform = iOS / Mac
def set_carthage_framework_search_paths_for_target(target, platform)
    target.build_configuration_list.set_setting(
        'FRAMEWORK_SEARCH_PATHS', "$(SRCROOT)/Carthage/Build/#{platform}"
    )
end

# platform = iOS / Mac
def make_carthage_build_path(name, platform)
    return "Carthage/Build/#{platform}/#{name}"
end

# platform = iOS / Mac
def add_input_path_to_script_phase(script_phase, name, platform)
    input_path = "$(SRCROOT)/#{make_carthage_build_path(name, platform)}"
    script_phase.input_paths << input_path
end

def integrate_osx_frameworks(containing_framework_name, *framework_names)

	project = project_from_name(containing_framework_name)
	osx_target = osx_target(project)

    script_phase = create_carthage_script_phase_for_target(osx_target)
    set_carthage_framework_search_paths_for_target(osx_target, 'Mac')

    #osx_frameworks_group(project).clear
	for embeddedFrameworkName in framework_names do
		ref = osx_frameworks_group(project).new_reference(
			make_carthage_build_path(embeddedFrameworkName, 'Mac')
		)
		osx_target.frameworks_build_phase.add_file_reference(ref))
        add_input_path_to_script_phase(script_phase, embeddedFrameworkName, 'Mac')
	end
	project.save
end


def integrate_ios_frameworks(containing_framework_name, *framework_names)
	project = project_from_name(containing_framework_name)
	ios_target = ios_target(project)
    
    script_phase = create_carthage_script_phase_for_target(ios_target)
    set_carthage_framework_search_paths_for_target(ios_target, 'iOS')

    #ios_frameworks_group(project).clear
	for embeddedFrameworkName in framework_names do
		ref = ios_frameworks_group(project).new_reference(
			make_carthage_build_path(embeddedFrameworkName, 'iOS')
		)
		ios_target.frameworks_build_phase.add_file_reference(ref)
        add_input_path_to_script_phase(script_phase, embeddedFrameworkName, 'iOS')
	end
	project.save
end