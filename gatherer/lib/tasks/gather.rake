
namespace :gather do
  desc "Gather photos"
  @begin_date = Time.mktime(2009, 03, 1)

  task :go, [:tag] => :environment do |t, args|
    gather_session = GatherSession.find_last_by_tag(args.tag)

    if (gather_session == nil)
      gather_session = GatherSession.new

      gather_session.begin_date = @begin_date
      gather_session.end_date = @begin_date.advance(:days => -1)
      gather_session.page_end = 1
      gather_session.tag = args.tag
    end
    gather_session.page_start = gather_session.end_date

    gather(gather_session)
  end

  def gather(gather_session)
    gather_session.save
    
    tag = gather_session.tag
    page = gather_session.page_end
    min_uploaded_date = gather_session.begin_date
    max_uploaded_date = gather_session.end_date

    puts "start gather"
    flickr ||= Flickr.new(RAILS_ROOT + "/config/flickr.yml")

    puts "start search"
    f_photos = flickr.photos.search(:has_geo => '1', :tags => tag, :page => page, :min_uploaded_date => min_uploaded_date, :max_uploaded_date => max_uploaded_date)

    puts "found #{f_photos.size} photo(s) on page #{page}"
    new_photos = 0
    new_owners = 0
    f_photos.each do |f_photo|
      owner = Owner.find_by_owner_id(f_photo.owner)
      if (owner == nil)
        owner = Owner.new
        owner.owner_id = f_photo.owner
        owner.name = f_photo.owner_name
        owner.save
        new_owners += 1
      end

      photo = Photo.find_by_photo_id(f_photo.id)
      if (photo != nil)
        next
      end
      photo = Photo.new
      photo.photo_id = f_photo.id
      photo.date_taken = f_photo.taken_at
      photo.farm = f_photo.farm
      photo.latitude = f_photo.latitude
      photo.longitude = f_photo.longitude
      photo.owner_id = owner.owner_id
      photo.secret = f_photo.secret
      photo.server = f_photo.server
      photo.tags = f_photo.tags
      photo.save

      new_photos += 1
    end
    puts "new owners: #{new_owners} new photos: #{new_photos}"
    gather_session.page_end += 1

    if (gather_session.page_end == f_photos.pages)
      gather_session.page_end = 1
      gather_session.begin_date = gather_session.end_date.advance(:days => -1)
      gather_session.end_date = gather_session.end_date.advance(:days => -2)
    end
    
    puts "recurse gather"
    gather(gather_session)
  end
end