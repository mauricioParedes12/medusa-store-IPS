#!/usr/bin/env python3
"""
Genera un burndown chart (PNG) y su dataset (JSON) a partir de los
issues de GitHub etiquetados con los sprints indicados.

Uso:
    python scripts/generate_burndown.py issues-sprint3.json issues-sprint4.json

Cada archivo de entrada debe ser la salida de:
    gh issue list --state all --label "sprint-N" \
        --json number,title,createdAt,closedAt,state
"""
import json
import sys
from datetime import date, datetime, timedelta

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt

# Rango real de los Sprints 3 y 4, según el cronograma del proyecto
SPRINT_START = date(2026, 6, 10)
SPRINT_END = date(2026, 7, 12)

OUTPUT_PNG = "img/burndown-chart.png"
OUTPUT_JSON = "img/burndown-data.json"


def load_issues(paths):
    """Combina los issues de todos los archivos, evitando duplicados."""
    issues = {}
    for path in paths:
        with open(path) as f:
            for issue in json.load(f):
                issues[issue["number"]] = issue
    return list(issues.values())


def parse_date(value):
    if not value:
        return None
    return datetime.fromisoformat(value.replace("Z", "+00:00")).date()


def build_burndown(issues, start, end):
    total = len(issues)
    days = [start + timedelta(days=i) for i in range((end - start).days + 1)]

    closed_dates = sorted(
        d for d in (parse_date(i.get("closedAt")) for i in issues) if d
    )

    ideal, actual = [], []
    step = total / (len(days) - 1) if len(days) > 1 else 0
    for i, day in enumerate(days):
        ideal.append(round(total - step * i, 2))
        closed_so_far = sum(1 for d in closed_dates if d <= day)
        actual.append(total - closed_so_far)

    return days, ideal, actual, total


def main():
    paths = sys.argv[1:]
    if not paths:
        print("Debes indicar al menos un archivo JSON de issues")
        sys.exit(1)

    issues = load_issues(paths)
    days, ideal, actual, total = build_burndown(issues, SPRINT_START, SPRINT_END)

    today = date.today()
    # No graficar la línea "Real" hacia el futuro
    actual_plot = [value if day <= today else None for value, day in zip(actual, days)]

    plt.figure(figsize=(9, 4.5))
    plt.plot(days, ideal, "--", color="#bbbbbb", label="Ideal")
    plt.plot(days, actual_plot, "-o", color="#2563eb", markersize=3, label="Real")
    plt.title(f"Burndown Chart — Sprint 3 y 4 ({total} issues)")
    plt.xlabel("Fecha")
    plt.ylabel("Issues restantes")
    plt.legend()
    plt.grid(alpha=0.3)
    plt.gcf().autofmt_xdate()
    plt.tight_layout()
    plt.savefig(OUTPUT_PNG, dpi=150)

    with open(OUTPUT_JSON, "w") as f:
        json.dump(
            {
                "generated_at": datetime.utcnow().isoformat() + "Z",
                "sprint_start": SPRINT_START.isoformat(),
                "sprint_end": SPRINT_END.isoformat(),
                "total_issues": total,
                "days": [d.isoformat() for d in days],
                "ideal": ideal,
                "actual": actual,
            },
            f,
            indent=2,
        )

    dias_en_cero = sum(1 for a in actual if a == 0)
    print(f"Burndown generado: {total} issues totales, {dias_en_cero} día(s) en 0.")


if __name__ == "__main__":
    main()