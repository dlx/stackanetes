local kpm = import "kpm.libjsonnet";

function(
  params={}
)

kpm.package({
  package: {
    name: "stackanetes/memcached",
    expander: "jinja2",
    author: "Quentin Machu",
    version: "0.1.0",
    description: "memcached",
    license: "Apache 2.0",
  },

  variables: {
    deployment: {
      control_node_label: "openstack-control-plane",

      image: {
        base: "quay.io/stackanetes/stackanetes-%s:barcelona",
        memcached: $.variables.deployment.image.base % "memcached"
      },
    },

    network: {
      port: 11211,
    },
  },

  resources: [
    // Deployments.
    {
      file: "deployment.yaml.j2",
      template: (importstr "templates/deployment.yaml.j2"),
      name: "memcached",
      type: "deployment",
    },

    // Services.
    {
      file: "service.yaml.j2",
      template: (importstr "templates/service.yaml.j2"),
      name: "memcached",
      type: "service",
    },
  ],

  deploy: [
    {
      name: "$self",
    },
  ]
}, params)
