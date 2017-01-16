require_relative 'utils.rb'

# ✓
def create_project(name)
   	project = Xcodeproj::Project.new("#{name}.xcodeproj")
	project.save		
end

# ✓
def configure_primary_group(name)
	project = project_from_name(name)
	primary_group = project.new_group("#{name}")
	supporting_files_group = primary_group.new_group("Supporting Files")
	supporting_files_group.new_file("#{name}/Info.plist")
	project.save
end

# ✓
def configure_tests_group(name)
	project = project_from_name(name)
	test_group = project.new_group("#{name}Tests")
	supporting_files_group = test_group.new_group("Supporting Files")
	supporting_files_group.new_file("#{name}Tests/Info.plist")
	project.save
end

# ✓
def configure_PBXGroups(name)
	configure_primary_group(name)
	configure_tests_group(name)
end

# ✓
def configure_ios_targets(name)
	project = project_from_name(name)
	ios_target = project.new_target(:framework, name, :ios, '9.3')
	ios_tests_target = project.new_target(:unit_test_bundle, "#{name}Tests", :ios, '9.3')
	ios_tests_target.add_dependency(ios_target)
	project.save
end

# ✓
def configure_osx_targets(name)
	project = project_from_name(name)
	osx_target = project.new_target(:framework, "#{name}Mac", :osx, '10.9')
	osx_tests_target = project.new_target(
		:unit_test_bundle, "#{name}MacTests", :osx, '10.9'
	)
	osx_tests_target.add_dependency(osx_target)
	project.save
end	

# ✓
def configure_targets(name)
	configure_ios_targets(name)
	configure_osx_targets(name)
end

# ✓
def configure_header(name)
	project = project_from_name(name)
	header_ref = project.main_group.new_file("#{name}/#{name}.h")	
	configure_header_for_ios_target(project, header_ref)
	configure_header_for_osx_target(project, header_ref)
	project.save
end

# ✓
def configure_header_for_ios_target(project, header_ref)
	ios_target = ios_target(project)
	ios_header_build_file = ios_target.add_file_references(
		[header_ref], 'header_build_file'
	)
	ios_header_build_file.first.settings = { 'ATTRIBUTES' => ['Public'] }
end

# ✓
def configure_header_for_osx_target(project, header_ref)
	osx_target = osx_target(project)	
	osx_header_build_file = osx_target.add_file_references([header_ref], 'header_build_file')
	osx_header_build_file.first.settings = { 'ATTRIBUTES' => ['Public'] }
end

# CONFIGURE BUILD CONFIGURATION SETTINGS

# ✓
def configure_ios_build_configuration_settings(name)
	project = project_from_name(name)
	ios_target = ios_target(project)
	settings = {
		'INFOPLIST_FILE' => "#{name}/Info.plist",
		'EMBEDDED_CONTENT_CONTAINS_SWIFT' => 'YES',
		'PRODUCT_NAME' => "#{name}"
	}
	settings.each do |key, val|
		ios_target.build_configuration_list.set_setting(key, val)
	end
	project.save
end


def configure_ios_tests_build_configuration_settings(name)
	project = project_from_name(name)
	ios_tests_target = ios_tests_target(project)
	settings = { 'INFOPLIST_FILE' => "#{name}Tests/Info.plist" }
	settings.each do |key, val|
		ios_tests_target.build_configuration_list.set_setting(key, val)
	end
	project.save
end

# ✓
def configure_osx_build_configuration_settings(name)
	project = project_from_name(name)
	osx_target = osx_target(project)
	settings = {
		'INFOPLIST_FILE' => "#{name}/Info.plist",
		'EMBEDDED_CONTENT_CONTAINS_SWIFT' => 'NO',
		'PRODUCT_NAME' => "#{name}",
		'CODE_SIGN_IDENTITY' => "-"
	}
	settings.each do |key, val|
		osx_target.build_configuration_list.set_setting(key, val)
	end
	project.save
end

# ✓
def configure_osx_tests_build_configuration_settings(name)
	project = project_from_name(name)
	osx_tests_target = osx_tests_target(project)
	settings = { 
		'INFOPLIST_FILE' => "#{name}Tests/Info.plist",
		'COMBINE_HIDPI_IMAGES' => 'YES'
	}
	settings.each do |key, val|
		osx_tests_target.build_configuration_list.set_setting(key, val)
	end
	project.save
end

# ✓
def configure_build_configuration_settings(name)
	
	# wrap up 
	project = project_from_name(name)
	project.build_configuration_list.set_setting('ENABLE_TESTABILITY', 'YES')
	project.save

	# wrap up
	configure_ios_build_configuration_settings(name)
	configure_ios_tests_build_configuration_settings(name)
	configure_osx_build_configuration_settings(name)
	configure_osx_tests_build_configuration_settings(name)
end

def add_copy_files_build_phase_for_ios_test_target(name)
	project = project_from_name(name)
	ios_tests_target = ios_tests_target(project)
	build_phase = ios_tests_target.new_copy_files_build_phase
	
	# refactor out
	file_ref = project.new(Xcodeproj::Project::Object::PBXFileReference)
	file_ref.set_source_tree("BUILT_PRODUCTS_DIR")
	file_ref.set_path("#{name}.framework")
	
	build_phase.add_file_reference(file_ref, true)
	project.save
end

def add_copy_files_build_phase_for_osx_test_target(name)
	project = project_from_name(name)
	osx_tests_target = osx_tests_target(project)
	build_phase = osx_tests_target.new_copy_files_build_phase
	
	# refactor out
	file_ref = project.new(Xcodeproj::Project::Object::PBXFileReference)
	file_ref.set_source_tree("BUILT_PRODUCTS_DIR")
	file_ref.set_path("#{name}.framework")
	
	build_phase.add_file_reference(file_ref, true)
	project.save
end

def add_copy_files_build_phase_for_test_targets(name)
	add_copy_files_build_phase_for_ios_test_target(name)
	add_copy_files_build_phase_for_osx_test_target(name)
end

# ✓
def share_schemes(name)
	project = project_from_name(name)
	project.recreate_user_schemes(true)
	Xcodeproj::XCScheme.share_scheme("#{Dir.pwd}/#{name}.xcodeproj", "#{name}")
	Xcodeproj::XCScheme.share_scheme("#{Dir.pwd}/#{name}.xcodeproj", "#{name}Mac")
end

# ✓
def add_testable_entry_for_ios_target(name)
	project = project_from_name(name)
	ios_tests_target = ios_tests_target(project)
	ios_scheme = ios_scheme(name)
	testable_entry = Xcodeproj::XCScheme::BuildAction::Entry.new(ios_tests_target)
	testable_entry.build_for_analyzing = false
	ios_scheme.build_action.add_entry(testable_entry)
	
	testable_ref = Xcodeproj::XCScheme::TestAction::TestableReference.new(ios_tests_target
	)
	ios_scheme.test_action.add_testable(testable_ref)
	ios_scheme.test_action.code_coverage_enabled = true
	ios_scheme.save!
	project.save
end

# ✓
def add_testable_entry_for_osx_target(name)
	project = project_from_name(name)
	osx_tests_target = osx_tests_target(project)
	osx_scheme = osx_scheme(name)
	testable_entry = Xcodeproj::XCScheme::BuildAction::Entry.new(osx_tests_target)
	testable_entry.build_for_analyzing = false
	osx_scheme.build_action.add_entry(testable_entry)
	
	testable_ref = Xcodeproj::XCScheme::TestAction::TestableReference.new(osx_tests_target)
	osx_scheme.test_action.add_testable(testable_ref)
	osx_scheme.test_action.code_coverage_enabled = true
	osx_scheme.save!
	project.save
end

# ✓
def configure_schemes(name)
	share_schemes(name)
	add_testable_entry_for_ios_target(name)
	add_testable_entry_for_osx_target(name)
end