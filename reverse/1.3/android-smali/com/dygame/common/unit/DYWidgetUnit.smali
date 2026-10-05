.class public Lcom/dygame/common/unit/DYWidgetUnit;
.super Lcom/dygame/common/unit/DYUnitBase;
.source "DYWidgetUnit.java"


# instance fields
.field protected mViews:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray",
            "<",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>()V
    .locals 1

    .prologue
    .line 10
    invoke-direct {p0}, Lcom/dygame/common/unit/DYUnitBase;-><init>()V

    .line 12
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Lcom/dygame/common/unit/DYWidgetUnit;->mViews:Landroid/util/SparseArray;

    return-void
.end method


# virtual methods
.method public getView(I)Landroid/view/View;
    .locals 3
    .param p1, "resId"    # I

    .prologue
    .line 24
    iget-object v2, p0, Lcom/dygame/common/unit/DYWidgetUnit;->mViews:Landroid/util/SparseArray;

    invoke-virtual {v2, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/view/View;

    .line 25
    .local v1, "view":Landroid/view/View;
    if-nez v1, :cond_0

    .line 26
    invoke-virtual {p0}, Lcom/dygame/common/unit/DYWidgetUnit;->getTarget()Lcom/dygame/common/unit/DYUnit$Target;

    move-result-object v0

    .line 27
    .local v0, "target":Lcom/dygame/common/unit/DYUnit$Target;
    invoke-interface {v0, p1}, Lcom/dygame/common/unit/DYUnit$Target;->findView(I)Landroid/view/View;

    move-result-object v1

    .line 28
    iget-object v2, p0, Lcom/dygame/common/unit/DYWidgetUnit;->mViews:Landroid/util/SparseArray;

    invoke-virtual {v2, p1, v1}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 31
    .end local v0    # "target":Lcom/dygame/common/unit/DYUnit$Target;
    :cond_0
    return-object v1
.end method

.method public onDestroy()V
    .locals 0

    .prologue
    .line 21
    return-void
.end method

.method public onLoad()V
    .locals 0

    .prologue
    .line 16
    return-void
.end method
