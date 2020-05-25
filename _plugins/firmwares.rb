require 'net/http'
require 'uri'
require 'nokogiri'
require 'pp'

FIRMWARE_PREFIX = 'gluon-ffhl'
FIRMWARE_VERSION = '0.12.0-1'

FIRMWARE_REGEX = Regexp.new('^' + FIRMWARE_PREFIX + '-' + FIRMWARE_VERSION + '-')
FIRMWARE_BASE = 'http://luebeck.freifunk.net/firmware/' + FIRMWARE_VERSION + '/'

GROUPS = {
  "8devices" => {
    models: [
      "Carambola2",
      "jalapeno",
    ],
    extract_rev: lambda { |model, suffix| nil },
  },
  "A5" => {
    models: [
      "v11",
    ],
    extract_rev: lambda { |model, suffix| nil },
  },
  "Aerohive" => {
    models: [
      "HiveAP-121",
      "HiveAP-330",
    ],
    extract_rev: lambda { |model, suffix| nil },
  },
  "ALFA Network" => {
    models: [
      "AP121",
      "AP121U",
      "Hornet UB",
      "N2 / N5",
      "Tube2H",
    ],
    extract_rev: lambda { |model, suffix| nil },
  },
  "Allnet" => {
    models: [
      "ALL0315N"
    ],
    extract_rev: lambda { |model, suffix| nil },
  },
  "Asus" => {
    models: [
      "RT-AC57U"
    ],
    extract_rev: lambda { |model, suffix| nil },
  },
  "AVM" => {
    models: [
      "FRITZ!Box 4020",
      "FRITZ!Box 4040",
      "FRITZ!WLAN Repeater 300E",
      "FRITZ!WLAN Repeater 450E",
    ],
    extract_rev: lambda { |model, suffix| nil },
  },
  "Buffalo" => {
    models: [
      "WZR-600DHP",
      "WZR-HP-AG300H",
      "WZR-HP-AG300H/WZR-600DHP",
      "WZR-HP-G300NH",
      "WZR-HP-G300NH2",
      "WZR-HP-G450H",
    ],
    extract_rev: lambda { |model, suffix| nil },
  },
  "D-Link" => {
    models: [
      "DAP-1330",
      "DIR-505",
      "DIR-615",
      "DIR-825",
      "DIR-860L",
    ],
    extract_rev: lambda { |model, suffix| /^-(((rev-|)|b).+?)(?:-sysupgrade)?\.(bin|img)$/.match(suffix)[1] },
  },
  "GL" => {
    models: [
      "MT300A",
      "MT300N",
      "MT750",
    ],
    extract_rev: lambda { |model, suffix| /^-(.+?)(?:-sysupgrade)?\.bin$/.match(suffix)[1] },
  },
  "GL.iNet" => {
    models: [
      "GL-AR150",
      "GL-AR300M",
      "GL-AR750",
      "GL-B1300",
    ],
    extract_rev: lambda { |model, suffix| /^-(.+?)(?:-sysupgrade)?\.bin$/.match(suffix)[1] },
  },
  "GL-iNet" => {
    models: [
      "6408A",
      "6416A",
    ],
    extract_rev: lambda { |model, suffix| /^-(.+?)(?:-sysupgrade)?\.bin$/.match(suffix)[1] },
  },
  "Lemaker" => {
    models: [
      "Banana Pi",
    ],
    extract_rev: lambda { |model, suffix| nil },
  },
  "Linksys" => {
    models: [
      "WRT160NL",
    ],
    extract_rev: lambda { |model, suffix| nil },
  },
  "Meraki" => {
    models: [
      "MR12",
      "MR16",
      "MR62",
      "MR66",
    ],
    extract_rev: lambda { |model, suffix| nil },
  },
  "NETGEAR" => {
    models: [
      "EX6100",
      "EX6150",
      "R6120",
      "WNDR3700",
      "WNDR3800",
      "WNDR4300",
      "WNDRMAC",
    ],
    extract_rev: lambda { |model, suffix| /^(.*?)(?:-sysupgrade)?\.[^.]+$/.match(suffix)[1].sub(/^$/, 'v1') },
  },
  "Nexx" => {
    models: [
      "WT3020AD",
      "WT3020F",
      "WT3020H",
      "WT3020 8M",
    ],
    extract_rev: lambda { |model, suffix| nil },
  },
  "Ocedo" => {
    models: [
      "Koala",
    ],
    extract_rev: lambda { |model, suffix| nil },
  },
  "Onion" => {
    models: [
      "Omega",
    ],
    extract_rev: lambda { |model, suffix| nil },
  },
  "OpenMesh" => {
    models: [
      "A40",
      "A42",
      "A60",
      "A62",
      "MR600",
      "MR900",
      "MR1750",
      "OM2P LC",
      "OM2P HS",
      "OM2P",
      "OM5P AN",
      "OM5P",
    ],
    extract_rev: lambda { |model, suffix| /((?:v\d)?)(?:-sysupgrade)?\.[^.]+$/.match(suffix)[1].sub(/^$/, 'v1') },
  },
  "Raspberry" => {
    models: [
      "Pi",
      "Pi 2",
    ],
    extract_rev: lambda { |model, suffix| nil },
  },
  "TP-Link" => {
    models: [
      "Archer C50",
      "Archer C58",
      "Archer C59",
      "Archer C60",
      "Archer C5",
      "Archer C7",
      "CPE210",
      "CPE220",
      "CPE510",
      "CPE520",
      "RE450",
      "TL-MR13U",
      "TL-MR3020",
      "TL-MR3040",
      "TL-MR3220",
      "TL-MR3420",
      "TL-WA701N/ND",
      "TL-WA7210N",
      "TL-WA730RE",
      "TL-WA750RE",
      "TL-WA7510N",
      "TL-WA801N/ND",
      "TL-WA830RE",
      "TL-WA850RE",
      "TL-WA860RE",
      "TL-WA901N/ND",
      "TL-WDR3500",
      "TL-WDR3600",
      "TL-WDR4300",
      "TL-WDR4900",
      "TL-WR1043N/ND",
      "TL-WR1043N",
      "TL-WR2543N/ND",
      "TL-WR703N",
      "TL-WR710N",
      "TL-WR740N/ND",
      "TL-WR741N/ND",
      "TL-WR743N/ND",
      "TL-WR810N",
      "TL-WR840N",
      "TL-WR841N/ND",
      "TL-WR841N",
      "TL-WR842N/ND",
      "TL-WR843N/ND",
      "TL-WR940N/ND",
      "TL-WR940N",
      "TL-WR941N/ND",
      "WBS210",
      "WBS510",
    ],
    extract_rev: lambda { |model, suffix| rev = /^(?:-(?!sysupgrade)(.+?))?(?:-sysupgrade)?\.bin$/.match(suffix)[1] },
  },
  "Ubiquiti" => {
    models: [
      "AirGateway",
      "AirRouter",
      "Bullet M",
      "Loco M",
      "Nanostation Loco M",
      "Nanostation M",
      "Picostation M",
      "Rocket M",
      "UniFi AP Pro",
      "UniFi",
      "UniFiAP Outdoor",
    ],
    extract_rev: lambda { |model, suffix|
      rev = /^(.*?)(?:-sysupgrade)?\.bin$/.match(suffix)[1]

      if rev == '-xw'
        'XW'
      elsif ['Bullet M',
             'Loco M',
             'Nanostation M',
             'Picostation M',
             'Rocket M',
            ].include? model
        'XM'
      else
        nil
      end
    },
    transform_label: lambda { |model|
      if model == 'UniFi' then
        'UniFi AP (LR)'
      else
        model
      end
    }
  },
  "Ubnt" => {
    models: [
      "ERX",
      "ERX-SFP",
    ],
    extract_rev: lambda { |model, suffix| nil },
  },
  "VoCore" => {
    models: [
      "",
    ],
    extract_rev: lambda { |model, suffix| nil },
  },

  "WD" => {
    models: [
      "My Net N600",
      "My Net N750",
    ],
    extract_rev: lambda { |model, suffix| nil },
  },
  "x86" => {
    models: [
      "Generic",
      "Geode",
      "KVM",
      "VirtualBox",
      "VMware",
      "XEN",
      "64",
    ],
    extract_rev: lambda { |model, suffix| nil },
  },
  "ZBT" => {
    models: [
      "WG3526 16M",
      "WG3526 32M",
    ],
    extract_rev: lambda { |model, suffix| nil },
  },
  "Zyxel" => {
    models: [
      "nbg6616",
      "nbg6617",
      "nbg6716",
      "wre6606",
    ],
    extract_rev: lambda { |model, suffix| nil },
  },
}

module Jekyll
  class Firmware
    attr_accessor :group
    attr_accessor :label
    attr_accessor :factory
    attr_accessor :sysupgrade
    attr_accessor :hwrev

    def to_liquid
      {
        "factory" => factory,
        "sysupgrade" => sysupgrade,
        "hwrev" => hwrev
      }
    end

    def to_s
      self.label
    end
  end

  class FirmwareListGenerator < Generator
    def generate(site)
      class << site
        attr_accessor :firmwares
        def site_payload
          result = super
          result["site"]["firmwares"] = self.firmwares
#          result["site"]["firmware_version"] = FIRMWARE_VERSION
          result["site"]["firmware_version"] = FIRMWARE_VERSION.gsub(/-[0-9]$/,'')
          result
        end
      end

      def get_files(url)
        uri = URI.parse(url)
        response = Net::HTTP.get_response uri
        doc = Nokogiri::HTML(response.body)
        doc.css('a').map do |link|
          link.attribute('href').to_s
        end.uniq.sort.select do |href|
          href.match(FIRMWARE_REGEX)
        end
      end

      def sanitize_model_name(name)
        name
          .downcase
          .gsub(/[^\w\-\.]+/, '-')
          .gsub(/\.+/, '.')
          .gsub(/[\-\.]*-[\-\.]*/, '-')
          .gsub(/-+$/, '')
      end

      def prefix_of(sub, str)
        str[0, sub.length].eql? sub
      end

      def find_prefix(name)
        @prefixes.each do |prefix|
          return prefix if prefix_of(prefix, name)
        end

        nil
      end

      firmwares = Hash[GROUPS.collect_concat { |group, info|
        info[:models].collect do |model|
          basename = FIRMWARE_PREFIX + '-' + FIRMWARE_VERSION + '-' + sanitize_model_name(group + ' ' + model)
          label = if info[:transform_label] then
                    info[:transform_label].call model
                  else
                    model
                  end
          [basename,
           {
             :extract_rev => info[:extract_rev],
             :model => model,
             :revisions => Hash.new { |hash, rev|
               fw = Firmware.new
               fw.label = label
               fw.group = group
               fw.hwrev = rev
               fw
             },
           }
          ]
        end
      }]

      @prefixes = firmwares.keys.sort_by { |p| p.length }.reverse

      factory = get_files(FIRMWARE_BASE + "factory/")
      sysupgrade = get_files(FIRMWARE_BASE + "sysupgrade/")

      factory.each do |href|
        basename = find_prefix href

        if basename then
          suffix = href[basename.length..-1]
          info = firmwares[basename]

          hwrev = info[:extract_rev].call info[:model], suffix

          fw = info[:revisions][hwrev]
          fw.factory = FIRMWARE_BASE + "factory/" + href
          info[:revisions][hwrev] = fw
        else
          $stderr.puts "WARNING: Unknown factory firmware " + href
        end
      end

      sysupgrade.each do |href|
        basename = find_prefix href

        if basename then
          suffix = href[basename.length..-1]
          info = firmwares[basename]

          hwrev = info[:extract_rev].call info[:model], suffix

          fw = info[:revisions][hwrev]
          fw.sysupgrade = FIRMWARE_BASE + "sysupgrade/" + href
          info[:revisions][hwrev] = fw
        else
          $stderr.puts "WARNING: Unknown sysupgrade firmware " + href
        end
      end

      firmwares.delete_if { |k, v| v[:revisions].empty? }

      groups = firmwares
               .collect { |k, v| v[:revisions] }
               .group_by { |revs| revs.values.first.label }
               .collect { |k, v| [k, v.first.sort_by {|x| x.first.to_s.scan(/[0-9]+|[^0-9]+/).map { |s| [s.to_i, s] }}] }
               .sort
               .group_by { |k, v| v.first[1].group }
               .to_a
               .sort

      site.firmwares = groups
    end
  end
end
