require 'spec_helper'


describe Assignment1::URIHelper do

  describe ".absolute_uri" do
    include Assignment1::URIHelper

    it "returns nil with invalid root" do
      expect( absolute_uri("invalid_root", '/a.html') ).to be_nil
    end

    it "returns nil with href = '#' " do
      expect( absolute_uri("http://localhost/a/b.html", '#') ).to be_nil
    end

    it "returns nil with nil href" do
      expect( absolute_uri("http://localhost/a/b.html", nil) ).to be_nil
    end

    it "returns nil with blank href" do
      expect( absolute_uri("http://localhost/a/b.html", '') ).to be_nil
      expect( absolute_uri("http://localhost/a/b.html", ' ') ).to be_nil
    end

    it "returns correct uri for relative path" do
      expect( absolute_uri("http://localhost/a/b.html", 'c.html') ).to eq("http://localhost/a/c.html")
      expect( absolute_uri("http://localhost/a/b.html", '/c.html') ).to eq("http://localhost/c.html")
    end

    it "returns correct uri for absolute path" do
      expect( absolute_uri("http://localhost/a.html", 'http://google.com/a.html') ).to eq("http://google.com/a.html")
    end

  end
end
