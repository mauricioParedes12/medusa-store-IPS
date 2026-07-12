type BadgeColor = "green" | "red" | "blue" | "orange" | "grey" | "purple"

export type OrderStatusInfo = {
  label: string
  color: BadgeColor
}

const formatStatusLabel = (status: string): string => {
  const formatted = status.split("_").join(" ")
  return formatted.charAt(0).toUpperCase() + formatted.slice(1)
}

export const getFulfillmentStatusInfo = (
  status?: string | null
): OrderStatusInfo => {
  if (!status) {
    return { label: "Unknown", color: "grey" }
  }

  const colorMap: Record<string, BadgeColor> = {
    not_fulfilled: "grey",
    partially_fulfilled: "orange",
    fulfilled: "blue",
    partially_shipped: "orange",
    shipped: "blue",
    partially_delivered: "orange",
    delivered: "green",
    canceled: "red",
  }

  return {
    label: formatStatusLabel(status),
    color: colorMap[status] ?? "grey",
  }
}

/**
 * Determina el color de Badge según el estado de pago del pedido.
 */
export const getPaymentStatusInfo = (
  status?: string | null
): OrderStatusInfo => {
  if (!status) {
    return { label: "Unknown", color: "grey" }
  }

  const colorMap: Record<string, BadgeColor> = {
    not_paid: "grey",
    awaiting: "orange",
    captured: "green",
    partially_captured: "orange",
    partially_refunded: "orange",
    refunded: "blue",
    canceled: "red",
    requires_action: "red",
  }

  return {
    label: formatStatusLabel(status),
    color: colorMap[status] ?? "grey",
  }
}