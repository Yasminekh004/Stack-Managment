 

function toggleAddForm() {
    const addForm = document.getElementById('addForm');
    addForm.style.display = addForm.style.display === 'none' ? 'block' : 'none';
}

function initBudgetCharts(pieChartId, barChartId, categories, amounts, totalSpent) {
    // Pie Chart for Budget by Category
    new Chart(document.getElementById(pieChartId), {
        type: 'pie',
        data: {
            labels: categories,
            datasets: [{
                data: amounts,
                backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40'],
                hoverOffset: 20
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { position: 'top' },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            const value = context.raw;
                            const percentage = ((value / totalSpent) * 100).toFixed(2);
                            return `${context.label}: $${value.toFixed(2)} (${percentage}%)`;
                        }
                    }
                }
            }
        }
    });

    // Bar Chart for Expenses by Category
    new Chart(document.getElementById(barChartId), {
        type: 'bar',
        data: {
            labels: categories,
            datasets: [{
                label: 'Expenses ($)',
                data: amounts,
                backgroundColor: '#36A2EB',
                borderColor: '#36A2EB',
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Amount ($)'
                    }
                },
                x: {
                    title: {
                        display: true,
                        text: 'Category'
                    }
                }
            },
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            const value = context.raw;
                            const percentage = ((value / totalSpent) * 100).toFixed(2);
                            return `$${value.toFixed(2)} (${percentage}%)`;
                        }
                    }
                }
            }
        }
    });
}

document.addEventListener('DOMContentLoaded', () => {
    // Search filter for dashboard
    const searchInput = document.querySelector('input[name="keyword"]');
    if (searchInput) {
        searchInput.addEventListener('input', () => {
            const keyword = searchInput.value.toLowerCase();
            const rows = document.querySelectorAll('table tbody tr');
            rows.forEach(row => {
                const name = row.cells[0].textContent.toLowerCase();
                row.style.display = name.includes(keyword) ? '' : 'none';
            });
        });
    }

    // Initialize charts for budgetDetails.jsp
    const pieChartCanvas = document.getElementById('budgetPieChart');
    if (pieChartCanvas) {
        const categories = JSON.parse(pieChartCanvas.dataset.categories || '[]');
        const amounts = JSON.parse(pieChartCanvas.dataset.amounts || '[]');
        const totalSpent = parseFloat(pieChartCanvas.dataset.totalSpent || '0');
        initBudgetCharts('budgetPieChart', 'expensesBarChart', categories, amounts, totalSpent);
    }
});



function toggleCustomCategory(value) {
        const customInput = document.getElementById("customCategory");
        const finalInput = document.getElementById("finalCategory");

        if (value === "Other") {
            customInput.style.display = "block";
            customInput.required = true;
            finalInput.value = customInput.value; // Initially blank or existing

            // Update final value as user types
            customInput.addEventListener("input", function () {
                finalInput.value = customInput.value;
            });
        } else {
            customInput.style.display = "none";
            customInput.required = false;
            finalInput.value = value;
        }
    }

    // On page load: set correct value
    document.addEventListener("DOMContentLoaded", function () {
        const selectedValue = document.getElementById("categorySelect").value;
        toggleCustomCategory(selectedValue);
    });