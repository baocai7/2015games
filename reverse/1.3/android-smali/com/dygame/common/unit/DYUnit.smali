.class public Lcom/dygame/common/unit/DYUnit;
.super Ljava/lang/Object;
.source "DYUnit.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/dygame/common/unit/DYUnit$Target;
    }
.end annotation


# static fields
.field protected static mTargets:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap",
            "<",
            "Ljava/lang/Object;",
            "Ljava/util/HashMap",
            "<",
            "Ljava/lang/String;",
            "Lcom/dygame/common/unit/DYUnitBase;",
            ">;>;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 13
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcom/dygame/common/unit/DYUnit;->mTargets:Ljava/util/HashMap;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 8
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 9
    return-void
.end method

.method public static addUnit(Lcom/dygame/common/unit/DYUnit$Target;Ljava/lang/Class;)Ljava/lang/Object;
    .locals 6
    .param p0, "target"    # Lcom/dygame/common/unit/DYUnit$Target;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<T:",
            "Ljava/lang/Object;",
            ">(",
            "Lcom/dygame/common/unit/DYUnit$Target;",
            "Ljava/lang/Class",
            "<TT;>;)TT;"
        }
    .end annotation

    .prologue
    .line 17
    .local p1, "cls":Ljava/lang/Class;, "Ljava/lang/Class<TT;>;"
    sget-object v5, Lcom/dygame/common/unit/DYUnit;->mTargets:Ljava/util/HashMap;

    invoke-virtual {v5, p0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/util/HashMap;

    .line 18
    .local v2, "targetUnits":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Lcom/dygame/common/unit/DYUnitBase;>;"
    if-nez v2, :cond_0

    .line 19
    new-instance v2, Ljava/util/HashMap;

    .end local v2    # "targetUnits":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Lcom/dygame/common/unit/DYUnitBase;>;"
    invoke-direct {v2}, Ljava/util/HashMap;-><init>()V

    .line 20
    .restart local v2    # "targetUnits":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Lcom/dygame/common/unit/DYUnitBase;>;"
    sget-object v5, Lcom/dygame/common/unit/DYUnit;->mTargets:Ljava/util/HashMap;

    invoke-virtual {v5, p0, v2}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 23
    :cond_0
    const/4 v3, 0x0

    .line 24
    .local v3, "unit":Lcom/dygame/common/unit/DYUnitBase;
    const/4 v4, 0x0

    .line 26
    .local v4, "unitRet":Ljava/lang/Object;, "TT;"
    :try_start_0
    invoke-virtual {p1}, Ljava/lang/Class;->newInstance()Ljava/lang/Object;

    move-result-object v5

    move-object v0, v5

    check-cast v0, Lcom/dygame/common/unit/DYUnitBase;

    move-object v3, v0

    .line 27
    invoke-virtual {v3, p0}, Lcom/dygame/common/unit/DYUnitBase;->setTarget(Lcom/dygame/common/unit/DYUnit$Target;)V

    .line 28
    invoke-virtual {v3}, Lcom/dygame/common/unit/DYUnitBase;->onLoad()V

    .line 29
    invoke-virtual {p1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v2, v5, v3}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/InstantiationException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_1

    .line 31
    move-object v4, v3

    .line 40
    .end local v4    # "unitRet":Ljava/lang/Object;, "TT;"
    :goto_0
    return-object v4

    .line 32
    .restart local v4    # "unitRet":Ljava/lang/Object;, "TT;"
    :catch_0
    move-exception v1

    .line 34
    .local v1, "e":Ljava/lang/InstantiationException;
    invoke-virtual {v1}, Ljava/lang/InstantiationException;->printStackTrace()V

    goto :goto_0

    .line 35
    .end local v1    # "e":Ljava/lang/InstantiationException;
    :catch_1
    move-exception v1

    .line 37
    .local v1, "e":Ljava/lang/IllegalAccessException;
    invoke-virtual {v1}, Ljava/lang/IllegalAccessException;->printStackTrace()V

    goto :goto_0
.end method

.method public static getUnit(Lcom/dygame/common/unit/DYUnit$Target;Ljava/lang/Class;)Ljava/lang/Object;
    .locals 2
    .param p0, "target"    # Lcom/dygame/common/unit/DYUnit$Target;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<T:",
            "Ljava/lang/Object;",
            ">(",
            "Lcom/dygame/common/unit/DYUnit$Target;",
            "Ljava/lang/Class",
            "<TT;>;)TT;"
        }
    .end annotation

    .prologue
    .line 45
    .local p1, "cls":Ljava/lang/Class;, "Ljava/lang/Class<TT;>;"
    sget-object v1, Lcom/dygame/common/unit/DYUnit;->mTargets:Ljava/util/HashMap;

    invoke-virtual {v1, p0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/HashMap;

    .line 46
    .local v0, "targetUnits":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Lcom/dygame/common/unit/DYUnitBase;>;"
    if-nez v0, :cond_0

    .line 47
    const/4 v1, 0x0

    .line 50
    :goto_0
    return-object v1

    :cond_0
    invoke-virtual {p1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    goto :goto_0
.end method

.method public static removeAllUnits(Lcom/dygame/common/unit/DYUnit$Target;)V
    .locals 5
    .param p0, "target"    # Lcom/dygame/common/unit/DYUnit$Target;

    .prologue
    .line 67
    sget-object v3, Lcom/dygame/common/unit/DYUnit;->mTargets:Ljava/util/HashMap;

    invoke-virtual {v3, p0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/HashMap;

    .line 68
    .local v1, "targetUnits":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Lcom/dygame/common/unit/DYUnitBase;>;"
    if-nez v1, :cond_0

    .line 78
    :goto_0
    return-void

    .line 72
    :cond_0
    invoke-virtual {v1}, Ljava/util/HashMap;->entrySet()Ljava/util/Set;

    move-result-object v3

    invoke-interface {v3}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :goto_1
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_1

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/Map$Entry;

    .line 73
    .local v0, "entry":Ljava/util/Map$Entry;, "Ljava/util/Map$Entry<Ljava/lang/String;Lcom/dygame/common/unit/DYUnitBase;>;"
    invoke-interface {v0}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/dygame/common/unit/DYUnitBase;

    .line 74
    .local v2, "unit":Lcom/dygame/common/unit/DYUnitBase;
    invoke-virtual {v2}, Lcom/dygame/common/unit/DYUnitBase;->onDestroy()V

    goto :goto_1

    .line 77
    .end local v0    # "entry":Ljava/util/Map$Entry;, "Ljava/util/Map$Entry<Ljava/lang/String;Lcom/dygame/common/unit/DYUnitBase;>;"
    .end local v2    # "unit":Lcom/dygame/common/unit/DYUnitBase;
    :cond_1
    invoke-virtual {v1}, Ljava/util/HashMap;->clear()V

    goto :goto_0
.end method

.method public static removeUnit(Lcom/dygame/common/unit/DYUnit$Target;Ljava/lang/Class;)V
    .locals 3
    .param p0, "target"    # Lcom/dygame/common/unit/DYUnit$Target;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<T:",
            "Ljava/lang/Object;",
            ">(",
            "Lcom/dygame/common/unit/DYUnit$Target;",
            "Ljava/lang/Class",
            "<TT;>;)V"
        }
    .end annotation

    .prologue
    .line 54
    .local p1, "cls":Ljava/lang/Class;, "Ljava/lang/Class<TT;>;"
    sget-object v2, Lcom/dygame/common/unit/DYUnit;->mTargets:Ljava/util/HashMap;

    invoke-virtual {v2, p0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/HashMap;

    .line 55
    .local v0, "targetUnits":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Lcom/dygame/common/unit/DYUnitBase;>;"
    if-nez v0, :cond_1

    .line 64
    :cond_0
    :goto_0
    return-void

    .line 59
    :cond_1
    invoke-virtual {p1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/dygame/common/unit/DYUnitBase;

    .line 60
    .local v1, "unit":Lcom/dygame/common/unit/DYUnitBase;
    if-eqz v1, :cond_0

    .line 61
    invoke-virtual {v1}, Lcom/dygame/common/unit/DYUnitBase;->onDestroy()V

    .line 62
    invoke-virtual {p1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/util/HashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_0
.end method
