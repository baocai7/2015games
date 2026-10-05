.class public abstract Lcom/dygame/common/unit/DYUnitBase;
.super Ljava/lang/Object;
.source "DYUnitBase.java"


# instance fields
.field private mTarget:Lcom/dygame/common/unit/DYUnit$Target;


# direct methods
.method protected constructor <init>()V
    .locals 1

    .prologue
    .line 11
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 9
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/dygame/common/unit/DYUnitBase;->mTarget:Lcom/dygame/common/unit/DYUnit$Target;

    .line 12
    return-void
.end method


# virtual methods
.method public getTarget()Lcom/dygame/common/unit/DYUnit$Target;
    .locals 1

    .prologue
    .line 19
    iget-object v0, p0, Lcom/dygame/common/unit/DYUnitBase;->mTarget:Lcom/dygame/common/unit/DYUnit$Target;

    return-object v0
.end method

.method public abstract onDestroy()V
.end method

.method public abstract onLoad()V
.end method

.method public setTarget(Lcom/dygame/common/unit/DYUnit$Target;)V
    .locals 0
    .param p1, "target"    # Lcom/dygame/common/unit/DYUnit$Target;

    .prologue
    .line 15
    iput-object p1, p0, Lcom/dygame/common/unit/DYUnitBase;->mTarget:Lcom/dygame/common/unit/DYUnit$Target;

    .line 16
    return-void
.end method
