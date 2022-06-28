"""
URL mappings for the recipe app.
"""
from django.urls import path, include

from rest_framework.routers import DefaultRouter

from recipe import views

# the default router takes care of creating and registering
# mappings to all available endpoints provided by the
# ModelViewSet class (CRUD)
router = DefaultRouter()
router.register('recipes', views.RecipeViewSet)
router.register('tags', views.TagViewSet)

app_name = 'recipe'

urlpatterns = [
    path('', include(router.urls)),
]
