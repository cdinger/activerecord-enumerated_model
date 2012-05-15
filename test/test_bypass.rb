require 'helper'

class TestBypass < Test::Unit::TestCase
  context "Some static model" do
    setup do
      ActiveRecord::Base.connection.create_table :static_things, :force => true do |t|
        t.string :name
      end
      ActiveRecord::Base.connection.execute("insert into static_things (name) values ('asdf')")
      class StaticThing < ActiveRecord::Base
        include ActiveRecord::EnumeratedModel
      end
    end

    teardown do
      ActiveRecord::Base.connection.drop_table :static_things
    end

    should "bypass readonly to destroy" do
      before_count = StaticThing.count
      StaticThing.bypass_readonly do
        t = StaticThing.first
        t.destroy
      end
      assert_not_equal(before_count, StaticThing.count)
    end

    should "bypass readonly to update" do
      StaticThing.bypass_readonly do
        thing = StaticThing.first
        thing.name = 'lkjasdflkjasdf'
        assert(thing.save)
      end
    end

    should "reload constants after bypass" do
      StaticThing.bypass_readonly do
        StaticThing.create(:name => 'new thing')
      end
      assert(StaticThing::NEW_THING)
    end
  end
end
