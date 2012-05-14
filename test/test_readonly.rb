require 'helper'

class TestReadonly < Test::Unit::TestCase
  context "Some static model" do
    setup do
      ActiveRecord::Base.connection.create_table :static_things, :force => true do |t|
        t.string :name
      end
      ActiveRecord::Base.connection.execute("insert into static_things (name) values ('Blah thing')")
      ActiveRecord::Base.connection.execute("insert into static_things (name) values ('''nother blah\" thing. !')")
      class StaticThing < ActiveRecord::Base
        include ActiveRecord::EnumeratedModel
      end
    end

    teardown do
      ActiveRecord::Base.connection.drop_table :static_things
    end

    should "prevent destroy" do
      before_count = StaticThing.count
      assert_raise ActiveRecord::ReadOnlyRecord do
        StaticThing.first.destroy
      end
      assert_equal(before_count, StaticThing.count)
    end

    #should "prevent delete" do
      #before_count = StaticThing.count
      #assert_raise ActiveRecord::ReadOnlyRecord do
        #StaticThing.delete_all
      #end
      #assert_equal(before_count, StaticThing.count)
    #end

    should "prevent update" do
      thing = StaticThing.first
      thing.name = 'something different'
      assert_raise ActiveRecord::ReadOnlyRecord do
        thing.save
      end
    end
  end
end

