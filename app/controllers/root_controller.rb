class RootController < ApplicationController
  def index
    build_dir = Rails.root.join('public/static/cwb/en')

    if build_dir.exist?
      current_build = build_dir.entries.find { |entry| entry.basename.to_s =~ /^[a-z0-9]{40}$/ }
      filepath = build_dir.join(current_build, 'index.html')

      render text: File.read(filepath)
    else
      render text: "Couldn't find the build."
    end
  end
end
