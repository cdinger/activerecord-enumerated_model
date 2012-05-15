require 'helper'

class TestEnumeration < Test::Unit::TestCase
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

    should "create constants" do
      assert(ActiveRecord::EnumeratedModel)
      assert_equal(StaticThing::BLAH_THING, StaticThing.first)
      assert_equal(StaticThing::NOTHER_BLAH_THING, StaticThing.last)
    end
  end

  context "Some static model without a name attribute" do
    setup do
      ActiveRecord::Base.connection.create_table :static_thingies, :force => true do |t|
        t.string :blah
      end
      ActiveRecord::Base.connection.execute("insert into static_thingies (blah) values ('ahoy hoy')")
      class StaticThingy < ActiveRecord::Base
        include ActiveRecord::EnumeratedModel
        create_enumeration_constants :blah
      end
    end

    teardown do
      ActiveRecord::Base.connection.drop_table :static_thingies
    end

    should "create constants" do
      assert(ActiveRecord::EnumeratedModel)
      assert_equal(StaticThingy::AHOY_HOY, StaticThingy.first)
    end
  end
end
