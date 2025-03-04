import lustre/attribute.{type Attribute}
import lustre/element.{type Element, element, namespaced}

pub fn input(attrs: List(Attribute(msg))) -> Element(msg) {
  element.element(
    "input",
    [
      attribute.class(
        "bg-neutral-900 border border-neutral-400 rounded-sm px-1 text-white",
      ),
      ..attrs
    ],
    [],
  )
}

pub fn button(
  attrs: List(Attribute(msg)),
  children: List(Element(msg)),
) -> Element(msg) {
  element.element(
    "button",
    [
      attribute.class(
        "bg-neutral-900 border border-neutral-400 rounded-sm text-white
        min-w-8 px-1
        flex justify-center items-center
        disabled:bg-neutral-600 disabled:cursor-not-allowed
        ",
      ),
      ..attrs
    ],
    children,
  )
}

pub fn select(
  attrs: List(Attribute(msg)),
  children: List(Element(msg)),
) -> Element(msg) {
  element.element(
    "select",
    [
      attribute.class(
        "bg-neutral-900 border border-neutral-400 rounded-sm text-white",
      ),
      ..attrs
    ],
    children,
  )
}
