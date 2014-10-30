# class GenerateThumbnail
#   include Sidekiq::Worker

#   def perform(path, rel_path, project_name)
#     logger.info "starting thumbnail generation"
#     source = Magick::Image.read(path.to_s).first
#     source.format = 'PNG'
#     thumb = source.resize_to_fill(240,240)
#     clean_name = project_name.gsub(' ', '_')
#     FileUtils::mkdir_p "system/#{clean_name}_thumbs"
#     thumb_name = BackgroundInit.scrub_path_to_png(rel_path.to_s)
#     logger.info "writing thumbnail"
#     thumb.write "system/#{clean_name}_thumbs/#{thumb_name}"
#     logger.info "finished thumbnail generation"
#   rescue => e
#     logger.info "error rescued!"
#     logger.info e.message
#     logger.info e.backtrace.join("\n")
#   end
# end