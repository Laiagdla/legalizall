namespae :assets do
  desc "Run both setup_assets and add_popper_to_manifest"
  task setup_all: :environment do
    Rake::Task['custom:setup_assets'].invoke
    Rake::Task['custom:add_popper_to_manifest'].invoke
  end
end

namespace :popper do
  desc "Ensure popper.js is linked in manifest.js"
  task add_popper_to_manifest: :environment do
    manifest_file = Rails.root.join('app', 'assets', 'config', 'manifest.js')
    popper_link = "//= link popper.js"

    # Check if the manifest.js file already contains the line
    if File.readlines(manifest_file).grep(/#{Regexp.quote(popper_link)}/).any?
      puts "'#{popper_link}' already exists in manifest.js"
    else
      File.open(manifest_file, 'a') { |file| file.puts popper_link }
      puts "'#{popper_link}' added to manifest.js"
    end
  end

  desc "add importmap settings"
  task importmap_popper: :environment do
    importmap_file = Rails.root.join('config', 'importmap.rb')
    popper_pin = "pin '@popperjs/core', to: 'popper.js', preload: true"
    if File.readlines(importmap_file).grep(/#{Regexp.quote(bootstrap_pin)}/).any?
      puts "'#{popper_pin}' already exists in manifest.js"
    else
      File.open(importmap_file, 'a') { |file| file.puts popper_pin }
      puts "'#{popper_pin}' added to manifest.js"
    end
  end
end

namespace :bootstrap do
  desc "Precompile assets and install Bootstrap and Popper.js"
  task setup_assets: :environment do
    # Run the Yarn command to install Bootstrap and Popper.js
    system("yarn add bootstrap @popperjs/core")

    # Precompile assets after installation
    Rake::Task['assets:precompile'].invoke
  end

  desc "add importmap settings"
  task importmap: :environment do
    importmap_file = Rails.root.join('config', 'importmap.rb')
    bootstrap_pin = "pin 'bootstrap', to: 'bootstrap.min.js', preload: true"
    if File.readlines(importmap_file).grep(/#{Regexp.quote(bootstrap_pin)}/).any?
      puts "'#{bootstrap_pin}' already exists in manifest.js"
    else
      File.open(importmap_file, 'a') do |file|
        file.puts bootstrap_pin
      end
      puts "'#{bootstrap_pin}' added to manifest.js"
    end
  end
end
