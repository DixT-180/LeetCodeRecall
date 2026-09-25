from django.urls import path
from . import views

urlpatterns = [
    path("register/", views.register, name="register"),
    path("login/", views.login_view, name="login"),
    path("logout/", views.logout_view, name="logout"),
    path("problem/", views.problem_list, name="home_problems"),
    path(
        "review-history/",
        views.review_history,
        name="review_history"
    ),
    path("", views.home, name="home"),
    path(
        "problem/<int:problemid>/",
        views.problem_detail,
        name="problem_detail"
    ),
    path(
        "problem/<int:problemid>/reset/",
        views.reset_problem_stats,
        name="reset_problem_stats"
    ),
    path(
        "solution/<int:solution_id>/delete/",
        views.delete_solution,
        name="delete_solution"
    ),
]