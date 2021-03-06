### GIVEN

Given /^I have an archivist "([^\"]*)"$/ do |name|
  user = find_or_create_new_user(name, "password")
  role = Role.find_or_create_by_name("archivist")
  user.roles = [role]
  user.save
end

Given /^I have pre-archivist setup for "([^\"]*)"$/ do |name|
  step(%{I am logged in as "#{name}"})
  step(%{I have loaded the "roles" fixture})
end

Given /^I have an Open Doors committee member "([^\"]*)"$/ do |name|
  step(%{I have pre-archivist setup for "#{name}"})
  step(%{I am logged in as an admin})
  step(%{I make "#{name}" an Open Doors committee member})
  step(%{I log out})
end

### WHEN

When /^I make "([^\"]*)" an archivist$/ do |name|
  step(%{I fill in "query" with "#{name}"})
    step(%{I press "Find"})
  step(%{I check "user_roles_4"})
    step(%{I press "Update"})
end

When /^I make "([^\"]*)" an Open Doors committee member$/ do |name|
  @user = User.find_by_login(name)
  @role = Role.find_or_create_by_name("opendoors")
  @user.roles = [@role]
end

When /^I start to import the work "([^\"]*)"(?: by "([^\"]*)" with email "([^\"]*)")?$/ do |url, external_author_name, external_author_email|
  step(%{I go to the import page})
  step(%{I check "Import for others ONLY with permission"})
  step(%{I fill in "urls" with "#{url}"})
  if external_author_name.present?
    step(%{I fill in "external_author_name" with "#{external_author_name}"})
    step(%{I fill in "external_author_email" with "#{external_author_email}"})
  end
end

When /^I import the work "(.*?)"(?: by "(.*?)" with email "(.*?)")?(?: and by "(.*?)" with email "(.*?)")?$/ do
      |url, creator_name, creator_email, cocreator_name, cocreator_email|
  step(%{I go to the import page})
  step(%{I check "Import for others ONLY with permission"})
  step(%{I fill in "urls" with "#{url}"})
  if creator_name.present?
    step(%{I fill in "external_author_name" with "#{creator_name}"})
    step(%{I fill in "external_author_email" with "#{creator_email}"})
  end
  if cocreator_name.present?
    step(%{I fill in "external_coauthor_name" with "#{cocreator_name}"})
    step(%{I fill in "external_coauthor_email" with "#{cocreator_email}"})
  end
  step(%{I check "Post without previewing"})
  step(%{I press "Import"})
end

When /^I import the works "([^\"]*)"$/ do |urls|
  urls = urls.split(/, ?/).join("\n")
  step(%{I go to the import page})
  step(%{I check "Import for others ONLY with permission"})
  step(%{I fill in "urls" with "#{urls}"})
  step(%{I check "Post without previewing"})
  step(%{I press "Import"})
end  

### THEN

Then /^I should not see multi-story import messages$/ do
  step %{I should not see "Importing completed successfully for the following works! (But please check the results over carefully!)"}
  step %{I should not see "Imported Works"}
  step %{I should not see "We were able to successfully upload the following works."}
end

Then /^I should see multi-story import messages$/ do
  step %{I should see "Importing completed successfully for the following works! (But please check the results over carefully!)"}
  step %{I should see "Imported Works"}
  step %{I should see "We were able to successfully upload the following works."}
end

Then /^I should see import confirmation$/ do
  step %{I should see "We have notified the author(s) you imported works for. If any were missed, you can also add co-authors manually."}
end

Then /^the email should contain invitation warnings from "([^\"]*)" for work "([^\"]*)" in fandom "([^\"]*)"$/ do |name, work, fandom|
  step %{the email should contain "has recently been imported"}
  step %{the email should contain "Open Doors"}
  step %{the email should contain "#{work}"}
  step %{the email should contain "#{fandom}"}
end

Then /^the email should contain claim information$/ do
  step %{the email should contain "automatically added to your AO3 account"}
end
