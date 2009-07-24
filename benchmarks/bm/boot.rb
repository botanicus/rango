# encoding: utf-8

require_relative "../helper"

RBench.run(100) do
  column :times
  column :one, title: "Hot boot"
  column :two, title: "Cold boot"

  report "Standard boot" do
    one do
      quiet! { Rango.boot }
    end

    two do
      load RANGO_LIBFILE
      quiet! { Rango.boot }
    end
  end
end
